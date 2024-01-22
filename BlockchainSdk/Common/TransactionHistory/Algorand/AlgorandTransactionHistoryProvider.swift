//
//  AlgorandHistoryProvider.swift
//  BlockchainSdk
//
//  Created by skibinalexander on 22.01.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation
import Combine

final class AlgorandTransactionHistoryProvider {
    
    /// Configuration connection node for provider
    private let node: AlgorandProviderNode
    
    // MARK: - Properties
    
    /// Network provider of blockchain
    private let network: NetworkProvider<AlgorandIndexProviderTarget>
    private let mapper: AlgorandTransactionHistoryMapper

    // MARK: - Init
    
    init(
        blockchain: Blockchain,
        node: AlgorandProviderNode,
        networkConfig: NetworkProviderConfiguration
    ) {
        self.node = node
        self.network = .init(configuration: networkConfig)
        self.mapper = .init(blockchain: blockchain)
    }
}

// MARK: - TransactionHistoryProvider

extension AlgorandTransactionHistoryProvider: TransactionHistoryProvider {
    func loadTransactionHistory(request: TransactionHistory.Request) -> AnyPublisher<TransactionHistory.Response, Error> {
        let target = AlgorandIndexProviderTarget(
            node: node,
            targetType: .getTransactions(
                address: request.address,
                limit: request.page.size,
                next: nil
            )
        )
        
        return network.requestPublisher(target)
            .filterSuccessfulStatusAndRedirectCodes()
            .map(AlgorandResponse.TransactionHistory.self)
            .withWeakCaptureOf(self)
            .tryMap { provider, response in
                let records = provider.mapper.mapToTransactionRecords(response, amountType: .coin)
                
                return .init(
                    totalPages: response.transactions.isEmpty ? 0 : nil,
                    totalRecordsCount: response.transactions.isEmpty ? 0 : nil,
                    page: Page(number: 0),
                    records: records
                )
            }
            .mapError { moyaError -> Swift.Error in
                return WalletError.failedToParseNetworkResponse
            }
            .eraseToAnyPublisher()
    }
}
