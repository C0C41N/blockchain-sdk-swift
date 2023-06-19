//
//  WalletManagerFactory.swift
//  BlockchainSdk
//
//  Created by Alexander Osokin on 06.12.2019.
//  Copyright © 2019 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk
import stellarsdk
import BitcoinCore
import Solana_Swift

@available(iOS 13.0, *)
public class WalletManagerFactory {
    
    private let config: BlockchainSdkConfig
    
    // MARK: - Init
    
    public init(config: BlockchainSdkConfig) {
        self.config = config
    }
    
    public func makeWalletManager(blockchain: Blockchain, publicKeys: [AddressType: Wallet.PublicKey]) throws -> WalletManager {
        // It'll moved in Assembly in next task
        let walletFactory = WalletFactory(addressProvider: blockchain.getAddressService())
        let wallet = try walletFactory.makeWallet(blockchain: blockchain, publicKeys: publicKeys)

        let input = WalletManagerAssemblyInput(
            blockchain: blockchain,
            blockchainConfig: config,
            pairPublicKey: nil,
            wallet: wallet,
            networkConfig: config.networkProviderConfiguration(for: blockchain)
        )

        return try blockchain.assembly.make(with: input)
    }
    
    /// Base wallet manager initializer
    /// - Parameters:
    ///   - blockchain: Card native blockchain will be used
    ///   - seedKey: Public key  of the wallet
    ///   - derivedKey: Derived ExtendedPublicKey by the card
    ///   - derivation: DerivationParams
    /// - Returns: WalletManager
    public func makeWalletManager(blockchain: Blockchain,
                                  seedKey: Data,
                                  derivedKey: ExtendedPublicKey,
                                  derivation derivationParams: DerivationParams) throws -> WalletManager {
        
        let derivation: Wallet.PublicKey.Derivation?
        
        switch derivationParams {
        case .default(let derivationStyle):
            if let derivationPath = blockchain.derivationPath(for: derivationStyle) {
                derivation = .init(path: derivationPath, derivedKey: derivedKey)
            } else {
                derivation = .none
            }
        case .custom(let path):
            derivation = .init(path: path, derivedKey: derivedKey)
        }
        
        let publicKey = Wallet.PublicKey(seedKey: seedKey, derivation: derivation)
        
        return try makeWalletManager(from: blockchain, publicKey: publicKey)
    }
    
    /// Legacy wallet manager initializer
    /// - Parameters:
    ///   - blockchain: Card native blockchain will be used
    ///   - walletPublicKey: Wallet's publicKey
    /// - Returns: WalletManager
    public func makeWalletManager(blockchain: Blockchain, walletPublicKey: Data) throws -> WalletManager {
        let publicKey = Wallet.PublicKey(seedKey: walletPublicKey, derivation: .none)
        
        return try makeWalletManager(from: blockchain, publicKey: publicKey)
    }
    
    /// Wallet manager initializer for twin cards
    /// - Parameters:
    ///   - blockchain: blockhain to create. If nil, card native blockchain will be used
    ///   - walletPublicKey: Wallet's publicKey
    public func makeTwinWalletManager(walletPublicKey: Data, pairKey: Data, isTestnet: Bool) throws -> WalletManager {
        let blockchain: Blockchain = .bitcoin(testnet: isTestnet)
        let publicKey = Wallet.PublicKey(seedKey: walletPublicKey, derivation: .none)
        
        return try makeWalletManager(
            from: blockchain,
            publicKey: publicKey,
            pairPublicKey: pairKey
        )
    }
    
    // MARK: - Private Implementation
    
    /// Private implementation factory creation wallet manager
    /// - Parameters:
    ///   - blockhain Card native blockchain will be used
    ///   - publicKey: Public key wallet
    ///   - pairPublicKey: Optional data pair public key
    /// - Returns: WalletManager model
    private func makeWalletManager(
        from blockchain: Blockchain,
        publicKey: Wallet.PublicKey,
        pairPublicKey: Data? = nil
    ) throws -> WalletManager {
        let addresses = try blockchain.makeAddresses(from: publicKey.blockchainKey, with: pairPublicKey)
        let wallet = Wallet(blockchain: blockchain, addresses: addresses, publicKey: publicKey)
        
        return try blockchain.assembly.make(
            with: .init(
                blockchain: blockchain,
                blockchainConfig: config,
                pairPublicKey: pairPublicKey,
                wallet: wallet,
                networkConfig: config.networkProviderConfiguration(for: blockchain)
            )
        )
    }
}

// MARK: - Stub Implementation

extension WalletManagerFactory {
    
    /// Use this method only Test and Debug [Addresses, Fees, etc.]
    /// - Parameters:
    ///   - blockhain Card native blockchain will be used
    ///   - walletPublicKey: Wallet public key or dummy input
    ///   - addresses: Dummy input addresses
    /// - Returns: WalletManager model
    public func makeStubWalletManager(
        blockchain: Blockchain,
        walletPublicKey: Data,
        addresses: [String]
    ) throws -> WalletManager {
        let publicKey: Wallet.PublicKey = .init(seedKey: walletPublicKey, derivation: .none)
        var addresses: [Address] = addresses.map { PlainAddress(value: $0, type: .default) }

        if addresses.isEmpty {
            addresses = try blockchain.makeAddresses(from: publicKey.blockchainKey, with: nil)
        }
        
        let wallet = Wallet(blockchain: blockchain, addresses: addresses, publicKey: publicKey)

        return try blockchain.assembly.make(
            with: .init(
                blockchain: blockchain,
                blockchainConfig: config,
                pairPublicKey: nil,
                wallet: wallet,
                networkConfig: config.networkProviderConfiguration(for: blockchain)
            )
        )
    }
    
}

// MARK: - DerivationParams

extension WalletManagerFactory {
    public enum DerivationParams {
        case `default`(DerivationStyle)
        case custom(DerivationPath)
    }
}