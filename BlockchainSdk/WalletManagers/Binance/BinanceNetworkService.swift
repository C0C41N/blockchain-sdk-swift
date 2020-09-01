//
//  BinanceNetworkService.swift
//  BlockchainSdk
//
//  Created by Alexander Osokin on 15.02.2020.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import BinanceChain
import Combine

class BinanceNetworkService {
    let binance: BinanceChain
    let address: String
    let testnet: Bool
    let assetCode: String?
    
    init(address: String, assetCode: String?, isTestNet:Bool) {
        self.address = address
        self.testnet = isTestNet
        self.assetCode = assetCode
        binance = isTestNet ? BinanceChain(endpoint: BinanceChain.Endpoint.testnet):
            BinanceChain(endpoint: BinanceChain.Endpoint.mainnet)
    }
    
    func getInfo() -> AnyPublisher<BinanceInfoResponse, Error> {
        let future = Future<BinanceInfoResponse,Error> {[unowned self] promise in
            self.binance.account(address: self.address) { response in
                guard let bnbBalance = response.account.balances.first(where: { $0.symbol == "BNB" }) else {
                    promise(.failure("Failed to load balance"))
                    return
                }
                
                let assetBalance = response.account.balances.first(where: { $0.symbol == self.assetCode})
                let accountNumber = response.account.accountNumber
                let sequence = response.sequence
                let info = BinanceInfoResponse(balance: bnbBalance.free, assetBalance: assetBalance?.free, accountNumber: accountNumber, sequence: sequence)
                promise(.success(info))
            }
        }
        return AnyPublisher(future)
    }
        
    @available(iOS 13.0, *)
    func getFee() -> AnyPublisher<String, Error> {
        let future = Future<String,Error> {[unowned self] promise in
            self.binance.fees { response in
                let fees: [String] = response.fees.compactMap { fee -> String? in
                    return fee.fixedFeeParams?.fee
                }
                
                guard let feeString = fees.first,
                    let decimalfee = Decimal(string: feeString) else {
                        promise(.failure("Failed to load fee"))
                        return
                }
                
                let convertedFee = (decimalfee/Decimal(100000000)).rounded(blockchain: .binance(testnet: self.testnet))
                let fee = "\(convertedFee)"
                promise(.success(fee))
            }
        }
        return AnyPublisher(future)
    }
    
    @available(iOS 13.0, *)
    func send(transaction: Message) -> AnyPublisher<Bool, Error> {
        let future = Future<Bool,Error> {[unowned self] promise in
            self.binance.broadcast(message: transaction, sync: true) { response in
                if let error = response.error {
                    promise(.failure(error))
                    return
                }
                promise(.success(true))
            }
        }
        return AnyPublisher(future)
    }
}

struct BinanceInfoResponse {
    let balance: Double
    let assetBalance: Double?
    let accountNumber: Int
    let sequence: Int
}
