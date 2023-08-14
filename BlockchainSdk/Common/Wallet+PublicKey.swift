//
//  Wallet+PublicKey.swift
//  BlockchainSdk
//
//  Created by Sergey Balashov on 30.05.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk

extension Wallet {
    public struct PublicKey: Codable, Hashable {
        public let seedKey: Data
        public let derivationType: DerivationType?

        /// Derived or non-derived key that should be used to create an address in a blockchain
        public var blockchainKey: Data {
            switch derivationType {
            case .none:
                return seedKey
            case .plain(let derivationKey):
                return derivationKey.extendedPublicKey.publicKey
            case .double(let first, let second):
                return CardanoUtil().extendPublicKey(first.extendedPublicKey, with: second.extendedPublicKey)
            }
        }

        public var derivationPath: DerivationPath? {
            derivationType?.derivationKey.path
        }

        public func xpubKey(isTestnet: Bool) -> String? {
            try? derivationType?.derivationKey.extendedPublicKey.serialize(for: isTestnet ? .testnet : .mainnet)
        }
        
        public init(seedKey: Data, derivationType: DerivationType?) {
            self.seedKey = seedKey
            self.derivationType = derivationType
        }
    }
}

extension Wallet.PublicKey {
    public enum DerivationType: Codable, Hashable {
        case plain(DerivationKey)

        /// Used only for Cardano
        case double(first: DerivationKey, second: DerivationKey)
        
        var derivationKey: DerivationKey {
            switch self {
            case .plain(let derivationKey):
                return derivationKey
            case .double(let derivationKey, _):
                return derivationKey
            }
        }
    }
    
    public struct DerivationKey: Codable, Hashable {
        let path: DerivationPath
        let extendedPublicKey: ExtendedPublicKey

        public init(path: DerivationPath, extendedPublicKey: ExtendedPublicKey) {
            self.path = path
            self.extendedPublicKey = extendedPublicKey
        }
    }
}
