//
//  ChiaWalletAssembly.swift
//  BlockchainSdk
//
//  Created by skibinalexander on 10.07.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation

struct ChiaWalletAssembly: WalletManagerAssembly {
    func make(with input: WalletManagerAssemblyInput) throws -> WalletManager {
        var providers: [ChiaNetworkProvider] = []
        
        if input.blockchain.isTestnet {
            providers.append(
                ChiaNetworkProvider(
                    node: .init(
                        apiKeyValue: input.blockchainSdkConfig.fireAcademyApiKeys.getApiKey(for: input.blockchain.isTestnet),
                        endpointType: .fireAcademy(isTestnet: input.blockchain.isTestnet)
                    ),
                    networkConfig: input.networkConfig
                )
            )
        } else {
            // ?
            providers.append(contentsOf: [
                ChiaNetworkProvider(
                    node: .init(apiKeyValue: input.blockchainSdkConfig.chiaTangemApiKeys.mainnetApiKey, endpointType: .tangem),
                    networkConfig: input.networkConfig
                ),
                ChiaNetworkProvider(
                    node: .init(
                        apiKeyValue: input.blockchainSdkConfig.fireAcademyApiKeys.getApiKey(for: input.blockchain.isTestnet),
                        endpointType: .fireAcademy(isTestnet: input.blockchain.isTestnet)
                    ),
                    networkConfig: input.networkConfig
                )
            ])
        }
        
        return try ChiaWalletManager(
            wallet: input.wallet,
            networkService: .init(
                providers: providers,
                blockchain: input.blockchain
            ),
            txBuilder: .init(
                isTestnet: input.blockchain.isTestnet,
                walletPublicKey: input.wallet.publicKey.blockchainKey
            )
        )
    }
}
