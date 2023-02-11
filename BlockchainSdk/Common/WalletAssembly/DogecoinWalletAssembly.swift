//
//  DogecoinAssembly.swift
//  BlockchainSdk
//
//  Created by skibinalexander on 08.02.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk
import BitcoinCore

struct DogecoinWalletAssembly: WalletAssemblyProtocol {
    
    static func make(with input: BlockchainAssemblyInput) throws -> AssemblyWallet {
        return try DogecoinWalletManager(wallet: input.wallet).then {
            let bitcoinManager = BitcoinManager(networkParams: DogecoinNetworkParams(),
                                                walletPublicKey: input.wallet.publicKey.blockchainKey,
                                                compressedWalletPublicKey: try Secp256k1Key(with: input.wallet.publicKey.blockchainKey).compress(),
                                                bip: .bip44)
            
            $0.txBuilder = BitcoinTransactionBuilder(bitcoinManager: bitcoinManager, addresses: input.wallet.addresses)
            
            var providers = [AnyBitcoinNetworkProvider]()
            
            providers.append(providerAssembly.makeBlockBookUtxoProvider(with: input, for: .nowNodes).eraseToAnyBitcoinNetworkProvider())
            providers.append(providerAssembly.makeBlockBookUtxoProvider(with: input, for: .getBlock).eraseToAnyBitcoinNetworkProvider())
            
            providers.append(
                contentsOf: providerAssembly.makeBlockchairNetworkProviders(endpoint: .dogecoin, with: input)
            )
            
            providers.append(
                providerAssembly.makeBlockcypherNetworkProvider(endpoint: .dogecoin, with: input).eraseToAnyBitcoinNetworkProvider()
            )
            
            $0.networkService = BitcoinNetworkService(providers: providers)
        }
    }
    
}
