//
//  TronNetworkService.swift
//  BlockchainSdk
//
//  Created by Andrey Chukavin on 24.03.2022.
//  Copyright © 2022 Tangem AG. All rights reserved.
//

import Foundation
import Combine
import BigInt
import web3swift

class TronNetworkService {
    private let blockchain: Blockchain
    private let rpcProvider: TronJsonRpcProvider
    
    init(blockchain: Blockchain, rpcProvider: TronJsonRpcProvider) {
        self.blockchain = blockchain
        self.rpcProvider = rpcProvider
    }
    
    func accountInfo(for address: String, tokens: [Token]) -> AnyPublisher<TronAccountInfo, Error> {
        let blockchain = self.blockchain
        let tokenBalancePublishers = tokens.map { tokenBalance(address: address, token: $0) }
        
        return rpcProvider.getAccount(for: address)
            .zip(Publishers.MergeMany(tokenBalancePublishers).collect())
            .map { (accountInfo, tokenInfoList) in
                let balance = Decimal(accountInfo.balance) / blockchain.decimalValue
                let tokenBalances = Dictionary(uniqueKeysWithValues: tokenInfoList)
                
                return TronAccountInfo(balance: balance, tokenBalances: tokenBalances)
            }
            .eraseToAnyPublisher()
    }
    
    func getAccount(for address: String) -> AnyPublisher<TronGetAccountResponse, Error> {
        rpcProvider.getAccount(for: address)
    }
    
    func createTransaction(from source: String, to destination: String, amount: UInt64) -> AnyPublisher<TronTransactionRequest, Error> {
        rpcProvider.createTransaction(from: source, to: destination, amount: amount)
    }
    
    func broadcastTransaction(_ transaction: TronTransactionRequest) -> AnyPublisher<TronBroadcastResponse, Error> {
        rpcProvider.broadcastTransaction(transaction)
    }
    
    func tokenBalance(address: String, token: Token) -> AnyPublisher<(Token, Decimal), Error> {
        rpcProvider.tokenBalance(address: address, contractAddress: token.contractAddress)
            .tryMap { response in
                guard let hexValue = response.constant_result.first else {
                    throw WalletError.failedToParseNetworkResponse
                }
                
                let bigIntValue = BigUInt(Data(hex: hexValue))
                
                let formatted = Web3.Utils.formatToPrecision(
                    bigIntValue,
                    numberDecimals: token.decimalCount,
                    formattingDecimals: token.decimalCount,
                    decimalSeparator: ".",
                    fallbackToScientific: false
                )
                
                guard let decimalValue = Decimal(formatted) else {
                    throw WalletError.failedToParseNetworkResponse
                }
                
                return (token, decimalValue)
            }
            .eraseToAnyPublisher()
    }
}
