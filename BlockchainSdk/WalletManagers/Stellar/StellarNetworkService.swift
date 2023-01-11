//
//  StellarNetworkService.swift
//  BlockchainSdk
//
//  Created by Alexander Osokin on 17.12.2019.
//  Copyright © 2019 Tangem AG. All rights reserved.
//

import Foundation
import stellarsdk
import Combine

@available(iOS 13.0, *)
class StellarNetworkService {
    let isTestnet: Bool
    let stellarSdk: StellarSDK
    
    var host: String {
        URL(string: stellarSdk.horizonURL)!.hostOrUnknown
    }
    
    private var blockchain: Blockchain {
        Blockchain.stellar(testnet: isTestnet)
    }
    
    init(isTestnet: Bool, stellarSdk: StellarSDK) {
        self.isTestnet = isTestnet
        self.stellarSdk = stellarSdk
    }
    
    public func send(transaction: String) -> AnyPublisher<Bool, Error> {
        return stellarSdk.transactions.postTransaction(transactionEnvelope: transaction)
            .tryMap{ submitTransactionResponse throws  -> Bool in
                if submitTransactionResponse.transactionResult.code == .success {
                    return true
                } else {
                    throw "Result code: \(submitTransactionResponse.transactionResult.code)"
                }
            }
            .mapError {[weak self] in self?.mapError($0) ?? WalletError.empty }
            .eraseToAnyPublisher()
    }
    
    public func getInfo(accountId: String, isAsset: Bool) -> AnyPublisher<StellarResponse, Error> {
        return stellarData(accountId: accountId)
            .tryMap{ [weak self] (accountResponse, ledgerResponse) throws -> StellarResponse in
                guard let self = self else {
                    throw WalletError.empty
                }

                let baseReserveStroops = Decimal(ledgerResponse.baseReserveInStroops)
                guard let balance = Decimal(accountResponse.balances.first(where: {$0.assetType == AssetTypeAsString.NATIVE})?.balance) else {
                          throw WalletError.failedToParseNetworkResponse
                      }
                
                let sequence = accountResponse.sequenceNumber
                let assetBalances = try accountResponse.balances
                    .filter ({ $0.assetType != AssetTypeAsString.NATIVE })
                    .map { assetBalance -> StellarAssetResponse in
                        guard let code = assetBalance.assetCode,
                              let issuer = assetBalance.assetIssuer,
                              let balance = Decimal(assetBalance.balance) else {
                                  throw WalletError.failedToParseNetworkResponse
                              }
                        
                        return StellarAssetResponse(code: code, issuer: issuer, balance: balance)
                    }
                
                let divider =  Blockchain.stellar(testnet: self.isTestnet).decimalValue
                let baseReserve = baseReserveStroops/divider
                
                return StellarResponse(baseReserve: baseReserve,
                                       assetBalances: assetBalances,
                                       balance: balance,
                                       sequence: sequence)
            }
            .mapError {[weak self] in self?.mapError($0, isAsset: isAsset) ?? WalletError.empty }
            .eraseToAnyPublisher()
    }
    
    public func getFee() -> AnyPublisher<[Amount], Error> {
        Publishers.Zip(stellarSdk.ledgers.getLatestLedger(),
                       stellarSdk.feeStats.getFeeStats())
        .tryMap { [blockchain] (ledger, feeStats) -> [Amount] in
            let baseFeeStroops = Decimal(ledger.baseFeeInStroops)
            guard let minChargedFeeStroops = Decimal(feeStats.feeCharged.min),
                let maxChargedFeeStroops = Decimal(feeStats.feeCharged.max)
            else {
                throw WalletError.failedToGetFee
            }

            let divider =  blockchain.decimalValue
            
            let baseFee = baseFeeStroops / divider
            let minChargedFee = minChargedFeeStroops / divider
            let maxChargedFee = maxChargedFeeStroops / divider
            
            let fees = [
                baseFee,
                (minChargedFee + maxChargedFee) / 2,
                maxChargedFee,
            ].map {
                Amount(with: blockchain, value: $0)
            }
            
            return fees
        }
        .eraseToAnyPublisher()
    }
    
    private func stellarData(accountId: String) -> AnyPublisher<(AccountResponse, LedgerResponse), Error> {
        Publishers.Zip(stellarSdk.accounts.getAccountDetails(accountId: accountId),
                       stellarSdk.ledgers.getLatestLedger())
            .eraseToAnyPublisher()
    }
    
    private func mapError(_ error: Error, isAsset: Bool? = nil) -> Error {
        if let horizonError = error as? HorizonRequestError {
            if case .notFound = horizonError, let isAsset = isAsset {
                let error: StellarError = isAsset ? .assetCreateAccount : .xlmCreateAccount
                return WalletError.noAccount(message: error.localizedDescription)
            } else {
                return horizonError.parseError()
            }
        } else {
            return error
        }
    }
}

extension StellarNetworkService {
    public func getSignatureCount(accountId: String) -> AnyPublisher<Int, Error> {
        stellarSdk.operations.getAllOperations(accountId: accountId, recordsLimit: 1)
            .map { items in
                items.filter { $0.sourceAccount == accountId }.count
            }
            .mapError {[weak self] in self?.mapError($0) ?? WalletError.empty }
            .eraseToAnyPublisher()
    }
}


struct StellarResponse {
    let baseReserve: Decimal
    let assetBalances: [StellarAssetResponse]
    let balance: Decimal
    let sequence: Int64
}

struct StellarAssetResponse {
    let code: String
    let issuer: String
    let balance: Decimal
}

struct StellarTargetAccountResponse {
    let accountCreated: Bool
    let trustlineCreated: Bool
}
