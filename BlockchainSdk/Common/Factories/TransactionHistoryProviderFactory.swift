//
//  TransactionHistoryProviderFactory.swift
//  BlockchainSdk
//
//  Created by Sergey Balashov on 03.08.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation

public struct TransactionHistoryProviderFactory {
    private let config: BlockchainSdkConfig
    
    // MARK: - Init
    
    public init(config: BlockchainSdkConfig) {
        self.config = config
    }
    
    public func makeProvider(for blockchain: Blockchain) -> TransactionHistoryProvider? {
        let networkAssembly = NetworkProviderAssembly()
        let input = CommonNetworkProviderAssemblyInput(blockchainSdkConfig: config, blockchain: blockchain)
        
        switch blockchain {
        case .bitcoin, .litecoin, .dogecoin, .dash:
            return BitcoinTransactionHistoryProvider(
                blockBookProviders: [
                    networkAssembly.makeBlockBookUtxoProvider(with: input, for: .getBlock),
                    networkAssembly.makeBlockBookUtxoProvider(with: input, for: .nowNodes)
                ],
                mapper: BitcoinTransactionHistoryMapper(blockchain: blockchain)
            )
        default:
            return nil
        }
    }
}
