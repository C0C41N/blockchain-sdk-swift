//
//  DerivationProviderTests.swift
//  BlockchainSdkTests
//
//  Created by Sergey Balashov on 24.05.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import XCTest

@testable import BlockchainSdk

class DerivationProviderTests: XCTestCase {
    func test_DerivationProviderV1() {
        Blockchain.allMainnetCases.forEach { blockchain in
            let expectingPaths = derivationPathsV1(blockchain: blockchain)
            let pathsV1 = blockchain.derivationPaths(for: .v1).reduce(into: [:], {
                $0[$1.key] = $1.value.rawPath
            })
            let pathsLegacy = blockchain.derivationPaths(for: .legacy).reduce(into: [:], {
                $0[$1.key] = $1.value.rawPath
            })
            XCTAssertEqual(expectingPaths, pathsV1, "Blockchain \(blockchain.displayName)")
            XCTAssertEqual(expectingPaths, pathsLegacy, "Blockchain \(blockchain.displayName)")
        }
    }
    
    func test_DerivationProviderV2() {
        Blockchain.allMainnetCases.forEach { blockchain in
            let expectingPaths = derivationPathsV2(blockchain: blockchain)
            let pathsV2 = blockchain.derivationPaths(for: .v2).reduce(into: [:], {
                $0[$1.key] = $1.value.rawPath
            })
            let pathsNew = blockchain.derivationPaths(for: .new).reduce(into: [:], {
                $0[$1.key] = $1.value.rawPath
            })
            XCTAssertEqual(expectingPaths, pathsV2, "Blockchain \(blockchain.displayName)")
            XCTAssertEqual(expectingPaths, pathsNew, "Blockchain \(blockchain.displayName)")
        }
    }
    
    func test_DerivationProviderV3() {
        Blockchain.allMainnetCases.forEach { blockchain in
            let expectingPaths = derivationPathsV3(blockchain: blockchain)
            let pathsV3 = blockchain.derivationPaths(for: .v3).reduce(into: [:], {
                $0[$1.key] = $1.value.rawPath
            })
            XCTAssertEqual(expectingPaths, pathsV3, "Blockchain \(blockchain.displayName)")
        }
    }
}

// MARK: - Expect Data

extension DerivationProviderTests {
    func derivationPathsV3(blockchain: Blockchain) -> [AddressType: String] {
       switch blockchain {
       case .bitcoin:
           return [
               .legacy: "m/44'/0'/0'/0/0",
               .default: "m/84'/0'/0'/0/0",
           ]
       case .litecoin:
           return [
               .legacy: "m/44'/2'/0'/0/0",
               .default: "m/84'/2'/0'/0/0",
           ]
       case .stellar:
           return [.default: "m/44'/148'/0'"]
       case .solana:
           return [.default: "m/44'/501'/0'"]
       case .cardano(let shelley):
           guard shelley else {
               return [:]
           }
           return [
               .legacy: "m/1852'/1815'/0'/0/0",
               .default: "m/1852'/1815'/0'/0/0"
           ]
       case .bitcoinCash:
           return [
               .legacy: "m/44'/145'/0'/0/0",
               .default: "m/44'/145'/0'/0/0",
           ]
       case .ethereum,
               .ethereumPoW,
               .ethereumFair,
               .ethereumClassic,
               .rsk,
               .bsc,
               .polygon,
               .avalanche,
               .fantom,
               .arbitrum,
               .gnosis,
               .optimism,
               .saltPay,
               .kava,
               .cronos:
           return [.default: "m/44'/60'/0'/0/0"]
       case .binance:
           return [.default: "m/44'/714'/0'/0/0"]
       case .xrp:
           return [.default: "m/44'/144'/0'/0/0"]
       case .ducatus:
           return [.default: "m/44'/0'/0'/0/0"]
       case .tezos:
           return [.default: "m/44'/1729'/0'/0/0"]
       case .dogecoin:
           return [.default: "m/44'/3'/0'/0/0"]
       case .polkadot:
           return [.default: "m/44'/354'/0'/0/0"]
       case .kusama:
           return [.default: "m/44'/434'/0'/0/0"]
       case .tron:
           return [.default: "m/44'/195'/0'/0/0"]
       case .dash:
           return [.default: "m/44'/5'/0'/0/0"]
       case .ton:
           return [.default: "m/44'/607'/0'/0/0"]
       case .kaspa:
           return [.default: "m/44'/111111'/0'/0/0"]
       case .ravencoin:
           return [.default: "m/44'/175'/0'/0/0"]
       case .cosmos:
           return [.default: "m/44'/118'/0'/0/0"]
       case .terraV1, .terraV2:
           return [.default: "m/44'/330'/0'/0/0"]
       }
   }
    
    func derivationPathsV2(blockchain: Blockchain) -> [AddressType: String] {
       switch blockchain {
       case .bitcoin:
           return [
               .legacy: "m/44'/0'/0'/0/0",
               .default: "m/44'/0'/0'/0/0",
           ]
       case .litecoin:
           return [
               .legacy: "m/44'/2'/0'/0/0",
               .default: "m/44'/2'/0'/0/0",
           ]
       case .stellar:
           return [.default: "m/44'/148'/0'"]
       case .solana:
           return [.default: "m/44'/501'/0'"]
       case .cardano(let shelley):
           guard shelley else {
               return [:]
           }
           return [
               .legacy: "m/1852'/1815'/0'/0/0",
               .default: "m/1852'/1815'/0'/0/0"
           ]
       case .bitcoinCash:
           return [
               .legacy: "m/44'/145'/0'/0/0",
               .default: "m/44'/145'/0'/0/0",
           ]
       case .ethereum,
               .ethereumPoW,
               .ethereumFair,
               .ethereumClassic,
               .rsk,
               .bsc,
               .polygon,
               .avalanche,
               .fantom,
               .arbitrum,
               .gnosis,
               .optimism,
               .saltPay,
               .kava,
               .cronos:
           return [.default: "m/44'/60'/0'/0/0"]
       case .binance:
           return [.default: "m/44'/714'/0'/0/0"]
       case .xrp:
           return [.default: "m/44'/144'/0'/0/0"]
       case .ducatus:
           return [.default: "m/44'/0'/0'/0/0"]
       case .tezos:
           return [.default: "m/44'/1729'/0'/0/0"]
       case .dogecoin:
           return [.default: "m/44'/3'/0'/0/0"]
       case .polkadot:
           return [.default: "m/44'/354'/0'/0/0"]
       case .kusama:
           return [.default: "m/44'/434'/0'/0/0"]
       case .tron:
           return [.default: "m/44'/195'/0'/0/0"]
       case .dash:
           return [.default: "m/44'/5'/0'/0/0"]
       case .ton:
           return [.default: "m/44'/607'/0'/0/0"]
       case .kaspa:
           return [.default: "m/44'/111111'/0'/0/0"]
       case .ravencoin:
           return [.default: "m/44'/175'/0'/0/0"]
       case .cosmos:
           return [.default: "m/44'/118'/0'/0/0"]
       case .terraV1, .terraV2:
           return [.default: "m/44'/330'/0'/0/0"]
       }
   }
    
    func derivationPathsV1(blockchain: Blockchain) -> [AddressType: String] {
       switch blockchain {
       case .bitcoin:
           return [
               .legacy: "m/44'/0'/0'/0/0",
               .default: "m/44'/0'/0'/0/0",
           ]
       case .litecoin:
           return [
               .legacy: "m/44'/2'/0'/0/0",
               .default: "m/44'/2'/0'/0/0",
           ]
       case .stellar:
           return [.default: "m/44'/148'/0'"]
       case .solana:
           return [.default: "m/44'/501'/0'"]
       case .cardano(let shelley):
           guard shelley else {
               return [:]
           }
           return [
               .legacy: "m/1852'/1815'/0'/0/0",
               .default: "m/1852'/1815'/0'/0/0"
           ]
       case .bitcoinCash:
           return [
               .legacy: "m/44'/145'/0'/0/0",
               .default: "m/44'/145'/0'/0/0",
           ]
       case .ethereum, .ethereumPoW, .ethereumFair, .saltPay:
           return [.default: "m/44'/60'/0'/0/0"]
       case .ethereumClassic:
           return [.default: "m/44'/61'/0'/0/0"]
       case .rsk:
           return [.default: "m/44'/137'/0'/0/0"]
       case .binance:
           return [.default: "m/44'/714'/0'/0/0"]
       case .xrp:
           return [.default: "m/44'/144'/0'/0/0"]
       case .ducatus:
           return [.default: "m/44'/0'/0'/0/0"]
       case .tezos:
           return [.default: "m/44'/1729'/0'/0/0"]
       case .dogecoin:
           return [.default: "m/44'/3'/0'/0/0"]
       case .bsc:
           return [.default: "m/44'/9006'/0'/0/0"]
       case .polygon:
           return [.default: "m/44'/966'/0'/0/0"]
       case .avalanche:
           return [.default: "m/44'/9000'/0'/0/0"]
       case .fantom:
           return [.default: "m/44'/1007'/0'/0/0"]
       case .polkadot:
           return [.default: "m/44'/354'/0'/0/0"]
       case .kusama:
           return [.default: "m/44'/434'/0'/0/0"]
       case .tron:
           return [.default: "m/44'/195'/0'/0/0"]
       case .arbitrum:
           return [.default: "m/44'/9001'/0'/0/0"]
       case .dash:
           return [.default: "m/44'/5'/0'/0/0"]
       case .gnosis:
           return [.default: "m/44'/700'/0'/0/0"]
       case .optimism:
           return [.default: "m/44'/614'/0'/0/0"]
       case .ton:
           return [.default: "m/44'/607'/0'/0/0"]
       case .kava:
           return [.default: "m/44'/459'/0'/0/0"]
       case .kaspa:
           return [.default: "m/44'/111111'/0'/0/0"]
       case .ravencoin:
           return [.default: "m/44'/175'/0'/0/0"]
       case .cosmos:
           return [.default: "m/44'/118'/0'/0/0"]
       case .terraV1, .terraV2:
           return [.default: "m/44'/330'/0'/0/0"]
       case .cronos:
           return [.default: "m/44'/10000025'/0'/0/0"]
       }
   }
}
