//
//  DecimalWalletAssembly.swift
//  BlockchainSdk
//
//  Created by skibinalexander on 15.11.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk

struct DecimalWalletAssembly: WalletManagerAssembly {
    
    func make(with input: WalletManagerAssemblyInput) throws -> WalletManager {
        let txBuilder = try DecimalTransactionBuilder(
            walletPublicKey: input.wallet.publicKey.blockchainKey,
            chainId: input.blockchain.chainId
        )

        let networkService = DecimalNetworkService(
            decimals: input.blockchain.decimalCount,
            providers: networkProviderAssembly.makeEthereumJsonRpcProviders(with: input),
            blockcypherProvider: nil,
            abiEncoder: WalletCoreABIEncoder()
        )

        return EthereumWalletManager(wallet: input.wallet, txBuilder: txBuilder, networkService: networkService)
    }
    
}
