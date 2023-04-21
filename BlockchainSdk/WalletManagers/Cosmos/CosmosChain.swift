//
//  CosmosChain.swift
//  BlockchainSdk
//
//  Created by Andrey Chukavin on 10.04.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation
import WalletCore

enum CosmosChain {
    case cosmos(testnet: Bool)
    
    // Terra Classic v1 (LUNC) and TerraUSD (USTC) are technically one blockchain.
    // But we choose to separate them into different entities because of fees.
    // When TerraUSD transactions are made we have a choice between paying in LUNC+USTC and just USTC.
    // The latter is simpler and more preferrable therefore the differentiation.
    case terraV1
    case terraV1USD
    
    case terraV2
    
    // ancient testnet network, we only use it for unit tests
    case gaia
}

// Keplr is a Cosmos network software wallet
// Keplr registry contains lots of goodies, for example:
// https://github.com/chainapsis/keplr-chain-registry/blob/main/cosmos/cosmoshub.json
extension CosmosChain {
    // https://cosmos.directory/cosmoshub
    func urls(for config: BlockchainSdkConfig) -> [String] {
        switch self {
        case .cosmos(let testnet):
            if testnet {
                return [
                    "https://rest.seed-01.theta-testnet.polypore.xyz",
                ]
            } else {
                return [
                    "https://atom.nownodes.io/\(config.nowNodesApiKey)",
                    "https://atom.getblock.io/\(config.getBlockApiKey)",
                    
                    "https://cosmos-mainnet-rpc.allthatnode.com:1317",
                    
                    // This is a REST proxy combining the servers below (and others)
                    "https://rest.cosmos.directory/cosmoshub",
                    
                    "https://cosmoshub-api.lavenderfive.com",
                    "https://rest-cosmoshub.ecostake.com",
                    "https://lcd.cosmos.dragonstake.io",
                ]
            }
        case .terraV1, .terraV1USD:
            return [
                "https://terra.nownodes.io/\(config.nowNodesApiKey)",
                "https://terra-classic-lcd.publicnode.com", // This is a redirect from https://columbus-lcd.terra.dev
            ]
        case .terraV2:
            return [
                "https://luna.getblock.io/\(config.getBlockApiKey)/mainnet",
                "https://phoenix-lcd.terra.dev", // Sometimes not responsive
            ]
        case .gaia:
            fatalError()
        }
    }
    
    // Either feeCurrencies/coinMinimalDenom from Keplr registry
    // or
    // params/bond_denom field from /cosmos/staking/v1beta1/params request
    var smallestDenomination: String {
        switch self {
        case .cosmos:
            return "uatom"
        case .terraV1, .terraV2:
            return "uluna"
        case .terraV1USD:
            return "uusd"
        case .gaia:
            return "muon"
        }
    }
    
    var blockchain: Blockchain {
        switch self {
        case .cosmos(let testnet):
            return .cosmos(testnet: testnet)
        case .terraV1:
            return .terraV1
        case .terraV1USD:
            return .terraV1USD
        case .terraV2:
            return .terraV2
        case .gaia:
            return .cosmos(testnet: true)
        }
    }
    
    // Either chainId from Keplr registry
    // or
    // node_info/network field from /node_info request
    var chainID: String {
        switch self {
        case .cosmos(let testnet):
            return testnet ? "theta-testnet-001" : "cosmoshub-4"
        case .terraV1, .terraV1USD:
            return "columbus-5"
        case .terraV2:
            return "phoenix-1"
        case .gaia:
            return "gaia-13003"
        }
    }
    
    // feeCurrencies/gasPriceStep field from Keplr registry
    var gasPrices: [Double] {
        switch self {
        case .cosmos:
            return [
                0.01,
                0.025,
                0.03,
            ]
        case .terraV1:
            return [
                28.325,
                28.325,
                28.325,
            ]
        case .terraV1USD:
            return [
                1,
                1,
                1,
            ]
        case .terraV2:
            return [
                0.015,
                0.025,
                0.040,
            ]
        case .gaia:
            fatalError()
        }
    }
    
    // Often times the value specified in Keplr is not enough:
    // >>> out of gas in location: WriteFlat; gasWanted: 76012, gasUsed: 76391: out of gas
    // >>> out of gas in location: ReadFlat; gasWanted: 124626, gasUsed: 125279: out of gas
    // Default multiplier value is 1
    var gasMultiplier: UInt64 {
        switch self {
        case .cosmos, .gaia:
            return 1
        case .terraV1:
            return 3
        case .terraV1USD:
            return 4
        case .terraV2:
            return 2
        }
    }
    
    // We use a formula to calculate the fee, by multiplying estimated gas by gas price.
    // But sometimes this is not enough:
    // >>> insufficient fees; got: 1005uluna required: 1006uluna: insufficient fee
    // Default multiplier value is 1
    var feeMultiplier: Double {
        switch self {
        case .cosmos, .gaia, .terraV1USD:
            return 1
        case .terraV1, .terraV2:
            return 1.5
        }
    }
    
    var coin: CoinType {
        switch self {
        case .cosmos, .gaia:
            return .cosmos
        case .terraV1, .terraV1USD:
            return .terra
        case .terraV2:
            return .terraV2
        }
    }
    
    var taxPercent: Decimal? {
        switch self {
        case .terraV1USD:
            return 0.2
        case .cosmos, .gaia, .terraV1, .terraV2:
            return nil
        }
    }
}
