//
//  CosmosNetworkService.swift
//  BlockchainSdk
//
//  Created by Andrey Chukavin on 10.04.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation
import Combine

class CosmosNetworkService: MultiNetworkProvider {
    let providers: [CosmosRestProvider]
    var currentProviderIndex: Int = 0
    
    private let cosmosChain: CosmosChain
    
    init(cosmosChain: CosmosChain, providers: [CosmosRestProvider]) {
        self.providers = providers
        self.cosmosChain = cosmosChain
    }
    
    func accountInfo(for address: String, tokens: [Token], transactionHashes: [String]) -> AnyPublisher<CosmosAccountInfo, Error> {
        providerPublisher {
            $0.accounts(address: address)
                .zip($0.balances(address: address), self.confirmedTransactionHashes(transactionHashes, with: $0))
                .tryMap { [weak self] (accountInfo, balanceInfo, confirmedTransactionHashes) in
                    guard
                        let self,
                        let sequenceNumber = UInt64(accountInfo?.account.sequence ?? "0")
                    else {
                        throw WalletError.failedToParseNetworkResponse
                    }
                    
                    let accountNumber: UInt64?
                    if let account = accountInfo?.account {
                        accountNumber = UInt64(account.accountNumber)
                    } else {
                        accountNumber = nil
                    }
                    
                    let rawAmount = try self.parseBalance(
                        balanceInfo,
                        denomination: self.cosmosChain.smallestDenomination,
                        decimalValue: self.cosmosChain.blockchain.decimalValue
                    )
                    let amount = Amount(with: self.cosmosChain.blockchain, value: rawAmount)
                    
                    let tokenAmounts: [Token: Decimal] = Dictionary(try tokens.compactMap {
                        guard let denomination = self.cosmosChain.tokenDenominationByContractAddress[$0.contractAddress] else {
                            return nil
                        }
                        
                        let balance = try self.parseBalance(balanceInfo, denomination: denomination, decimalValue: $0.decimalValue)
                        return ($0, balance)
                    }, uniquingKeysWith: {
                        pair1, _ in
                        pair1
                    })
                    
                    return CosmosAccountInfo(
                        accountNumber: accountNumber,
                        sequenceNumber: sequenceNumber,
                        amount: amount,
                        tokenBalances: tokenAmounts,
                        confirmedTransactionHashes: confirmedTransactionHashes
                    )
                }
                .eraseToAnyPublisher()
        }
    }
    
    func estimateGas(for transaction: Data) -> AnyPublisher<UInt64, Error> {
        providerPublisher {
            $0.simulate(data: transaction)
                .map(\.gasInfo.gasUsed)
                .tryMap {
                    guard let gasUsed = UInt64($0) else {
                        throw WalletError.failedToGetFee
                    }
                    
                    return gasUsed
                }
                .eraseToAnyPublisher()
        }
    }
    
    func send(transaction: Data) -> AnyPublisher<String, Error> {
        providerPublisher {
            $0.txs(data: transaction)
                .map(\.txResponse.txhash)
                .eraseToAnyPublisher()
        }
    }
    
    private func confirmedTransactionHashes(_ hashes: [String], with provider: CosmosRestProvider) -> AnyPublisher<[String], Error> {
        hashes
            .publisher
            .setFailureType(to: Error.self)
            .flatMap { [weak self] hash -> AnyPublisher<String?, Error> in
                guard let self = self else {
                    return .anyFail(error: WalletError.empty)
                }
                return self.transactionConfirmed(hash, with: provider)
            }
            .collect()
            .map {
                $0.compactMap { $0 }
            }
            .eraseToAnyPublisher()
    }
    
    private func transactionConfirmed(_ hash: String, with provider: CosmosRestProvider) -> AnyPublisher<String?, Error> {
        provider.transactionStatus(hash: hash)
            .map(\.txResponse)
            .compactMap { response in
                if let height = UInt64(response.height),
                   height > 0 {
                    return hash
                } else {
                    return nil
                }
            }
            .tryCatch { error -> AnyPublisher<String?, Error> in
                if case WalletError.failedToParseNetworkResponse = error {
                    return Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                throw error
            }
            .eraseToAnyPublisher()
    }
    
    private func parseBalance(_ balanceInfo: CosmosBalanceResponse, denomination: String, decimalValue: Decimal) throws -> Decimal {
        guard let balanceAmountString = balanceInfo.balances.first(where: { $0.denom == denomination } )?.amount else {
            return .zero
        }
        
        guard let balanceInSmallestDenomination = Int(balanceAmountString) else {
            throw WalletError.failedToParseNetworkResponse
        }
        
        return Decimal(balanceInSmallestDenomination) / decimalValue
    }
}