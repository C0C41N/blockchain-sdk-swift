//
//  BitcoinCashWalletAssembly.swift
//  BlockchainSdk
//
//  Created by skibinalexander on 08.02.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk
import stellarsdk
import BitcoinCore

struct BitcoinCashWalletAssembly: BlockchainAssemblyProtocol {
    
    func assembly(with input: BlockchainAssemblyInput) throws -> AssemblyWallet {
        return try BitcoinCashWalletManager(wallet: input.wallet).then {
            let compressed = try Secp256k1Key(with: input.wallet.publicKey.blockchainKey).compress()
            let bitcoinManager = BitcoinManager(networkParams: input.blockchain.isTestnet ? BitcoinCashTestNetworkParams() : BitcoinCashNetworkParams(),
                                                walletPublicKey: compressed,
                                                compressedWalletPublicKey: compressed,
                                                bip: .bip44)
            
            $0.txBuilder = BitcoinTransactionBuilder(bitcoinManager: bitcoinManager, addresses: input.wallet.addresses)
            
            //TODO: Add testnet support. Maybe https://developers.cryptoapis.io/technical-documentation/general-information/what-we-support
            var providers = [AnyBitcoinNetworkProvider]()
            
            if !input.blockchain.isTestnet {
                providers.append(BlockBookUtxoProvider(blockchain: input.blockchain,
                                                       blockBookConfig: NowNodesBlockBookConfig(apiKey: input.blockchainConfig.nowNodesApiKey),
                                                       networkConfiguration: input.networkConfig)
                    .eraseToAnyBitcoinNetworkProvider())
                
                providers.append(BlockBookUtxoProvider(blockchain: input.blockchain,
                                                       blockBookConfig: GetBlockBlockBookConfig(apiKey: input.blockchainConfig.getBlockApiKey),
                                                       networkConfiguration: input.networkConfig)
                    .eraseToAnyBitcoinNetworkProvider())
            }
            
            providers.append(contentsOf: makeBlockchairNetworkProviders(for: .bitcoinCash,
                                                                        configuration: input.networkConfig,
                                                                        apiKeys: input.blockchainConfig.blockchairApiKeys))
            
            $0.networkService = BitcoinCashNetworkService(providers: providers)
        }
    }
    
}
