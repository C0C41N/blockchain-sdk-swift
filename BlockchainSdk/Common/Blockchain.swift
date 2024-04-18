//
//  Blockchain.swift
//  blockchainSdk
//
//  Created by Alexander Osokin on 04.12.2019.
//  Copyright © 2019 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk
import BitcoinCore
import enum WalletCore.CoinType

// MARK: - Base
@available(iOS 13.0, *)
// This enum should be indirect because of memory issues on iOS15
public indirect enum Blockchain: Equatable, Hashable {
    case bitcoin(testnet: Bool)
    case litecoin
    case stellar(curve: EllipticCurve, testnet: Bool)
    case ethereum(testnet: Bool)
    case ethereumPoW(testnet: Bool)
    case disChain // ex-EthereumFair
    case ethereumClassic(testnet: Bool)
    case rsk
    case bitcoinCash
    case binance(testnet: Bool)
    case cardano(extended: Bool)
    case xrp(curve: EllipticCurve)
    case ducatus
    case tezos(curve: EllipticCurve)
    case dogecoin
    case bsc(testnet: Bool)
    case polygon(testnet: Bool)
    case avalanche(testnet: Bool)
    case solana(curve: EllipticCurve, testnet: Bool)
    case fantom(testnet: Bool)
    case polkadot(curve: EllipticCurve, testnet: Bool)
    case kusama(curve: EllipticCurve)
    case azero(curve: EllipticCurve, testnet: Bool)
    case tron(testnet: Bool)
    case arbitrum(testnet: Bool)
    case dash(testnet: Bool)
    case gnosis
    case optimism(testnet: Bool)
    case ton(curve: EllipticCurve, testnet: Bool)
    case kava(testnet: Bool)
    case kaspa
    case ravencoin(testnet: Bool)
    case cosmos(testnet: Bool)
    case terraV1
    case terraV2
    case cronos
    case telos(testnet: Bool)
    case octa
    case chia(testnet: Bool)
    case near(curve: EllipticCurve, testnet: Bool)
    case decimal(testnet: Bool)
    case veChain(testnet: Bool)
    case xdc(testnet: Bool)
    case algorand(curve: EllipticCurve, testnet: Bool)
    case shibarium(testnet: Bool)
    case aptos(curve: EllipticCurve, testnet: Bool)
    case hedera(curve: EllipticCurve, testnet: Bool)
    case areon(testnet: Bool)
    case playa3ullGames
    case pulsechain(testnet: Bool)
    case aurora(testnet: Bool)
    case manta(testnet: Bool)
    case zkSync(testnet: Bool)
    case moonbeam(testnet: Bool)
    case polygonZkEVM(testnet: Bool)
    case moonriver(testnet: Bool)
    case mantle(testnet: Bool)
    case flare(testnet: Bool)
    case taraxa(testnet: Bool)
    case radiant(testnet: Bool)
    case base(testnet: Bool)

    public var isTestnet: Bool {
        switch self {
        case .bitcoin(let testnet),
                .ethereum(let testnet),
                .bsc(let testnet),
                .ethereumClassic(let testnet),
                .binance(let testnet),
                .polygon(let testnet),
                .avalanche(let testnet),
                .fantom(let testnet),
                .tron(let testnet),
                .arbitrum(let testnet),
                .dash(let testnet),
                .optimism(let testnet),
                .ethereumPoW(let testnet),
                .kava(let testnet),
                .ravencoin(let testnet),
                .cosmos(let testnet),
                .telos(let testnet),
                .chia(let testnet),
                .decimal(let testnet),
                .veChain(let testnet),
                .xdc(let testnet),
                .areon(let testnet),
                .pulsechain(let testnet),
                .aurora(let testnet),
                .manta(let testnet),
                .zkSync(let testnet),
                .moonbeam(let testnet),
                .polygonZkEVM(let testnet),
                .moonriver(let testnet),
                .mantle(let testnet),
                .flare(let testnet),
                .taraxa(let testnet),
                .radiant(let testnet),
                .base(let testnet):
            return testnet
        case .litecoin,
                .ducatus,
                .cardano,
                .xrp,
                .rsk,
                .tezos,
                .dogecoin,
                .kusama,
                .terraV1,
                .terraV2,
                .cronos,
                .octa,
                .bitcoinCash,
                .gnosis,
                .disChain,
                .playa3ullGames,
                .kaspa:
            return false
        case .stellar(_, let testnet),
                .hedera(_, let testnet),
                .solana(_, let testnet),
                .polkadot(_, let testnet),
                .azero(_, let testnet),
                .ton(_, let testnet),
                .near(_, let testnet),
                .algorand(_, let testnet),
                .aptos(_, let testnet),
                .shibarium(let testnet):
            return testnet
        }
    }

    public var curve: EllipticCurve {
        switch self {
        case .cardano:
            return .ed25519
        case .stellar(let curve, _),
                .solana(let curve, _),
                .polkadot(let curve, _),
                .kusama(let curve),
                .azero(let curve, _),
                .ton(let curve, _),
                .xrp(let curve),
                .tezos(let curve),
                .near(let curve, _),
                .algorand(let curve, _),
                .aptos(let curve, _),
                .hedera(let curve, _):
            return curve
        case .chia:
            return .bls12381_G2_AUG
        default:
            return .secp256k1
        }
    }

    public var decimalCount: Int {
        switch self {
        case .bitcoin,
                .litecoin,
                .bitcoinCash,
                .ducatus,
                .binance,
                .dogecoin,
                .dash,
                .kaspa,
                .ravencoin,
                .hedera,
                .radiant:
            return 8
        case .ethereum,
                .ethereumClassic,
                .ethereumPoW,
                .disChain,
                .rsk,
                .bsc,
                .polygon,
                .avalanche,
                .fantom,
                .arbitrum,
                .gnosis,
                .optimism,
                .kava,
                .cronos,
                .telos,
                .octa,
                .decimal,
                .veChain,
                .xdc,
                .shibarium,
                .areon,
                .playa3ullGames,
                .pulsechain,
                .aurora,
                .manta,
                .zkSync,
                .moonbeam,
                .polygonZkEVM,
                .moonriver,
                .mantle,
                .flare,
                .taraxa,
                .base:
            return 18
        case .cardano,
                .xrp,
                .tezos,
                .tron,
                .cosmos,
                .terraV1,
                .terraV2:
            return 6
        case .stellar:
            return 7
        case .solana, .ton:
            return 9
        case .polkadot(_, let testnet):
            return testnet ? 12 : 10
        case .kusama,
                .azero,
                .chia:
            return 12
        case .near:
            return 24
        case .algorand:
            return 6
        case .aptos:
            return 8
        }
    }

    public var currencySymbol: String {
        switch self {
        case .bitcoin:
            return "BTC"
        case .litecoin:
            return "LTC"
        case .stellar:
            return "XLM"
        case .ethereum,
             .arbitrum,
             .optimism,
             .aurora,
             .manta,
             .zkSync,
             .polygonZkEVM,
             .base:
            return "ETH"
        case .ethereumClassic:
            return "ETC"
        case .rsk:
            return "RBTC"
        case .bitcoinCash:
            return "BCH"
        case .binance:
            return "BNB"
        case .ducatus:
            return "DUC"
        case .cardano:
            return "ADA"
        case .xrp:
            return "XRP"
        case .tezos:
            return "XTZ"
        case .dogecoin:
            return "DOGE"
        case .bsc:
            return "BNB"
        case .polygon:
            return "MATIC"
        case .avalanche:
            return "AVAX"
        case .solana:
            return "SOL"
        case .fantom:
            return "FTM"
        case .polkadot(_, let testnet):
            return testnet ? "WND" : "DOT"
        case .kusama:
            return "KSM"
        case .azero:
            return "AZERO"
        case .tron:
            return "TRX"
        case .dash(let testnet):
            return testnet ? "tDASH" : "DASH"
        case .gnosis:
            return "xDAI"
        case .ethereumPoW:
            return "ETHW"
        case .disChain:
            return "DIS"
        case .ton:
            return "TON"
        case .kava:
            return "KAVA"
        case .kaspa:
            return "KAS"
        case .ravencoin:
            return "RVN"
        case .cosmos:
            return "ATOM"
        case .terraV1:
            return "LUNC"
        case .terraV2:
            return "LUNA"
        case .cronos:
            return "CRO"
        case .telos:
            return "TLOS"
        case .octa:
            return "OCTA"
        case .chia(let testnet):
            return testnet ? "TXCH" : "XCH"
        case .near:
            return "NEAR"
        case .decimal:
            return "DEL"
        case .veChain:
            return "VET"
        case .xdc:
            return "XDC"
        case .algorand:
            return "ALGO"
        case .shibarium:
            return "BONE"
        case .aptos:
            return "APT"
        case .hedera:
            return "HBAR"
        case .areon:
            return isTestnet ? "TAREA" : "AREA"
        case .playa3ullGames:
            return "3ULL"
        case .pulsechain:
            return isTestnet ? "tPLS" : "PLS"
        case .moonbeam:
            return isTestnet ? "DEV" : "GLMR"
        case .moonriver:
            return isTestnet ? "DEV" : "MOVR"
        case .mantle:
            return "MNT"
        case .flare:
            return isTestnet ? "C2FLR" : "FLR"
        case .taraxa:
            return "TARA"
        case .radiant:
            return "RXD"
        }
    }

    public var displayName: String {
        let testnetSuffix = isTestnet ? " Testnet" : ""

        switch self {
        case .bitcoinCash:
            return "Bitcoin Cash" + testnetSuffix
        case .ethereumClassic:
            return "Ethereum Classic" + testnetSuffix
        case .ethereumPoW:
            return "Ethereum PoW" + testnetSuffix
        case .disChain:
            return "DisChain (ETHF)" + testnetSuffix
        case .xrp:
            return "XRP Ledger"
        case .rsk:
            return "\(self)".uppercased()
        case .bsc:
            return "BNB Smart Chain" + testnetSuffix
        case .binance:
            return "BNB Beacon Chain" + testnetSuffix
        case .avalanche:
            return "Avalanche C-Chain" + testnetSuffix
        case .fantom:
            return isTestnet ? "Fantom" + testnetSuffix : "Fantom Opera"
        case .polkadot:
            return "Polkadot" + testnetSuffix + (isTestnet ? " (Westend)" : "")
        case .azero:
            return "Aleph Zero" + testnetSuffix
        case .gnosis:
            return "Gnosis Chain" + testnetSuffix
        case .optimism:
            return "Optimistic Ethereum" + testnetSuffix
        case .kava:
            return "Kava EVM"
        case .terraV1:
            return "Terra Classic"
        case .terraV2:
            return "Terra"
        case .octa:
            return "OctaSpace"
        case .chia:
            return "Chia Network"
        case .near:
            return "NEAR Protocol" + testnetSuffix
        case .decimal:
            return "Decimal Smart Chain" + testnetSuffix
        case .xdc:
            return "XDC Network"
        case .arbitrum:
            return "Arbitrum One" + testnetSuffix
        case .playa3ullGames:
            return "PLAYA3ULL GAMES"
        case .pulsechain:
            let testnetSuffix = testnetSuffix + (isTestnet ? " v4" : "")
            return "Pulsechain" + testnetSuffix
        case .polygonZkEVM:
            return "Polygon zkEVM" + testnetSuffix
        case .zkSync:
            return "zkSync Era" + testnetSuffix
        case .manta:
            return "Manta Pacific" + testnetSuffix
        default:
            var name = "\(self)".capitalizingFirstLetter()
            if let index = name.firstIndex(of: "(") {
                name = String(name.prefix(upTo: index))
            }
            return name + testnetSuffix
        }
    }

    /// Should be used as blockchain identifier
    public var coinId: String {
        id(type: .coin)
    }

    /// Should be used to:
    /// - Get a list of coins as the `networkIds` parameter
    /// - Synchronization of user coins on the server
    public var networkId: String {
        id(type: .network)
    }

    public var tokenTypeName: String? {
        switch self {
        case .ethereum: return "ERC20"
        case .binance: return "BEP2"
        case .bsc: return "BEP20"
        case .tron: return "TRC20"
        case .ton: return "TON"
        case .veChain: return "VIP180"
        case .xdc: return "XRC20"
        default:
            return nil
        }
    }

    public var canHandleTokens: Bool {
        switch self {
        case .taraxa:
            return false
        case .binance,
                .solana,
                .tron,
                .terraV1,
                .veChain,
                .cardano:
            return true
        case _ where isEvm:
            return true
        default:
            return false
        }
    }

    public var feePaidCurrency: FeePaidCurrency {
        switch self {
        case .terraV1:
            return .sameCurrency
        case .veChain:
            return .token(value: VeChainWalletManager.Constants.energyToken)
        default:
            return .coin
        }
    }

    public func isFeeApproximate(for amountType: Amount.AmountType) -> Bool {
        switch self {
        case .arbitrum,
                .stellar,
                .optimism,
                .ton,
                .near,
                .aptos,
                .hedera,
                .areon,
                .playa3ullGames,
                .pulsechain,
                .aurora,
                .manta,
                .zkSync,
                .moonbeam,
                .polygonZkEVM,
                .moonriver,
                .mantle,
                .flare,
                .taraxa,
                .base:
            return true
        case .fantom,
                .tron,
                .gnosis,
                .avalanche,
                .ethereumPoW,
                .cronos,
                .veChain,
                .xdc:
            if case .token = amountType {
                return true
            }
        default:
            break
        }

        return false
    }
}

// MARK: - Ethereum based blockchain definition
@available(iOS 13.0, *)
extension Blockchain {
    public var isEvm: Bool { chainId != nil }

    // Only for Ethereum compatible blockchains
    // https://chainlist.org
    public var chainId: Int? {
        switch self {
        case .ethereum: return isTestnet ? 5 : 1
        case .ethereumClassic: return isTestnet ? 6 : 61 // https://besu.hyperledger.org/en/stable/Concepts/NetworkID-And-ChainID/
        case .ethereumPoW: return isTestnet ? 10002 : 10001
        case .disChain: return 513100
        case .rsk: return 30
        case .bsc: return isTestnet ? 97 : 56
        case .polygon: return isTestnet ? 80001 : 137
        case .avalanche: return isTestnet ? 43113 : 43114
        case .fantom: return isTestnet ? 4002 : 250
        case .arbitrum: return isTestnet ? 421613 : 42161
        case .gnosis: return 100
        case .optimism: return isTestnet ? 420 : 10
        case .kava: return isTestnet ? 2221 : 2222
        case .cronos: return 25
        case .telos: return isTestnet ? 41 : 40
        case .octa: return isTestnet ? 800002 : 800001
        case .decimal: return isTestnet ? 202020 : 75
        case .xdc: return isTestnet ? 51 : 50
        case .shibarium: return isTestnet ? 157 : 109
        case .areon: return isTestnet ? 462 : 463
        case .playa3ullGames: return 3011
        case .pulsechain: return isTestnet ? 943 : 369
        case .aurora: return isTestnet ? 1313161555 : 1313161554
        case .manta: return isTestnet ? 3441005 : 169
        case .zkSync: return isTestnet ? 300 : 324 
        case .moonbeam: return isTestnet ? 1287 : 1284
        case .polygonZkEVM: return isTestnet ? 2442 : 1101
        case .moonriver: return isTestnet ? 1287 : 1285
        case .mantle: return isTestnet ? 5001 : 5000
        case .flare: return isTestnet ? 114 : 14
        case .taraxa: return isTestnet ? 842 : 841
        case .base: return isTestnet ? 84532 : 8453
        default: return nil
        }
    }
}

// MARK: - Address creation
@available(iOS 13.0, *)
extension Blockchain {
    public func derivationPath(for style: DerivationStyle) -> DerivationPath? {
        guard curve.supportsDerivation else {
            Log.debug("Wrong attempt to get a `DerivationPath` for a unsupported derivation curve")
            return nil
        }

        if isTestnet {
            return BIP44(coinType: 1).buildPath()
        }

        return style.provider.derivationPath(for: self)
    }
}

// MARK: - Sharing options
@available(iOS 13.0, *)
extension Blockchain {
    public var qrPrefixes: [String] {
        switch self {
        case .bitcoin:
            return ["bitcoin:"]
        case .ethereum:
            return isTestnet ? [] : ["ethereum:", "ethereum:pay-"]  // "pay-" defined in ERC-681
        case .litecoin:
            return ["litecoin:"]
        case .xrp:
            return ["xrpl:", "ripple:", "xrp:"]
        case .binance:
            return ["bnb:"]
        case .dogecoin:
            return ["doge:", "dogecoin:"]
        default:
            return []
        }
    }

    public func getShareString(from address: String) -> String {
        switch self {
        case .bitcoin, .ethereum, .litecoin, .binance:
            return "\(qrPrefixes.first ?? "")\(address)"
        default:
            return "\(address)"
        }
    }
}

// MARK: - Codable
@available(iOS 13.0, *)
extension Blockchain: Codable {
    public var codingKey: String {
        switch self {
        case .binance: return "binance"
        case .bitcoin: return "bitcoin"
        case .bitcoinCash: return "bitcoinCash"
        case .cardano: return "cardano"
        case .ducatus: return "ducatus"
        case .ethereum: return "ethereum"
        case .ethereumClassic: return "ethereumClassic"
        case .litecoin: return "litecoin"
        case .rsk: return "rsk"
        case .stellar: return "stellar"
        case .tezos: return "tezos"
        case .xrp: return "xrp"
        case .dogecoin: return "dogecoin"
        case .bsc: return "bsc"
        case .polygon: return "polygon"
        case .avalanche: return "avalanche"
        case .solana: return "solana"
        case .fantom: return "fantom"
        case .polkadot: return "polkadot"
        case .kusama: return "kusama"
        case .azero: return "aleph-zero"
        case .tron: return "tron"
        case .arbitrum: return "arbitrum"
        case .dash: return "dash"
        case .gnosis: return "xdai"
        case .optimism: return "optimism"
        case .ethereumPoW: return "ethereum-pow-iou"
        case .disChain: return "ethereumfair" // keep existing key for compatibility
        case .ton: return "ton"
        case .kava: return "kava"
        case .kaspa: return "kaspa"
        case .ravencoin: return "ravencoin"
        case .cosmos: return "cosmos-hub"
        case .terraV1: return "terra"
        case .terraV2: return "terra-2"
        case .cronos: return "cronos"
        case .telos: return "telos"
        case .octa: return "octaspace"
        case .chia: return "chia"
        case .near: return "near"
        case .decimal: return "decimal"
        case .veChain: return "vechain"
        case .xdc: return "xdc"
        case .algorand: return "algorand"
        case .shibarium: return "shibarium"
        case .aptos: return "aptos"
        case .hedera: return "hedera"
        case .areon: return "areon-network"
        case .playa3ullGames: return "playa3ull-games"
        case .pulsechain: return "pulsechain"
        case .aurora: return "aurora"
        case .manta: return "manta-network"
        case .zkSync: return "zksync"
        case .moonbeam: return "moonbeam"
        case .polygonZkEVM: return "polygon-zkevm"
        case .moonriver: return "moonriver"
        case .mantle: return "mantle"
        case .flare: return "flare"
        case .taraxa: return "taraxa"
        case .radiant: return "radiant"
        case .base: return "base"
        }
    }

    enum Keys: CodingKey {
        case key
        case testnet
        case curve
        case extended
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let key = try container.decode(String.self, forKey: Keys.key)
        let curveString = try container.decode(String.self, forKey: Keys.curve)
        let isTestnet = try container.decode(Bool.self, forKey: Keys.testnet)

        guard let curve = EllipticCurve(rawValue: curveString) else {
            throw BlockchainSdkError.decodingFailed
        }

        switch key {
        case "bitcoin": self = .bitcoin(testnet: isTestnet)
        case "stellar": self = .stellar(curve: curve, testnet: isTestnet)
        case "ethereum": self = .ethereum(testnet: isTestnet)
        case "ethereumClassic": self = .ethereumClassic(testnet: isTestnet)
        case "litecoin": self = .litecoin
        case "rsk": self = .rsk
        case "bitcoinCash": self = .bitcoinCash
        case "binance": self = .binance(testnet: isTestnet)
        case "cardano":
            let extended = try container.decodeIfPresent(Bool.self, forKey: Keys.extended)
            self = .cardano(extended: extended ?? false)
        case "xrp": self = .xrp(curve: curve)
        case "ducatus": self = .ducatus
        case "tezos": self = .tezos(curve: curve)
        case "dogecoin": self = .dogecoin
        case "bsc": self = .bsc(testnet: isTestnet)
        case "polygon", "matic": self = .polygon(testnet: isTestnet)
        case "avalanche": self = .avalanche(testnet: isTestnet)
        case "solana": self = .solana(curve: curve, testnet: isTestnet)
        case "fantom": self = .fantom(testnet: isTestnet)
        case "polkadot": self = .polkadot(curve: curve, testnet: isTestnet)
        case "kusama": self = .kusama(curve: curve)
        case "aleph-zero": self = .azero(curve: curve, testnet: isTestnet)
        case "tron": self = .tron(testnet: isTestnet)
        case "arbitrum": self = .arbitrum(testnet: isTestnet)
        case "dash": self = .dash(testnet: isTestnet)
        case "xdai": self = .gnosis
        case "optimism": self = .optimism(testnet: isTestnet)
        case "ethereum-pow-iou": self = .ethereumPoW(testnet: isTestnet)
        case "ethereumfair", "dischain": self = .disChain
        case "ton": self = .ton(curve: curve, testnet: isTestnet)
        case "kava": self = .kava(testnet: isTestnet)
        case "kaspa": self = .kaspa
        case "ravencoin": self = .ravencoin(testnet: isTestnet)
        case "cosmos-hub": self = .cosmos(testnet: isTestnet)
        case "terra": self = .terraV1
        case "terra-2": self = .terraV2
        case "cronos": self = .cronos
        case "telos": self = .telos(testnet: isTestnet)
        case "octaspace": self = .octa
        case "chia": self = .chia(testnet: isTestnet)
        case "near": self = .near(curve: curve, testnet: isTestnet)
        case "decimal": self = .decimal(testnet: isTestnet)
        case "vechain": self = .veChain(testnet: isTestnet)
        case "xdc": self = .xdc(testnet: isTestnet)
        case "algorand": self = .algorand(curve: curve, testnet: isTestnet)
        case "shibarium": self = .shibarium(testnet: isTestnet)
        case "aptos": self = .aptos(curve: curve, testnet: isTestnet)
        case "hedera": self = .hedera(curve: curve, testnet: isTestnet)
        case "areon-network": self = .areon(testnet: isTestnet)
        case "playa3ull-games": self = .playa3ullGames
        case "pulsechain": self = .pulsechain(testnet: isTestnet)
        case "aurora": self = .aurora(testnet: isTestnet)
        case "manta-network": self = .manta(testnet: isTestnet)
        case "zksync": self = .zkSync(testnet: isTestnet)
        case "moonbeam": self = .moonbeam(testnet: isTestnet)
        case "polygon-zkevm": self = .polygonZkEVM(testnet: isTestnet)
        case "moonriver": self = .moonriver(testnet: isTestnet)
        case "mantle": self = .mantle(testnet: isTestnet)
        case "flare": self = .flare(testnet: isTestnet)
        case "taraxa": self = .taraxa(testnet: isTestnet)
        case "radiant": self = .radiant(testnet: isTestnet)
        case "base": self = .base(testnet: isTestnet)
        default:
            throw BlockchainSdkError.decodingFailed
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(codingKey, forKey: Keys.key)
        try container.encode(curve.rawValue, forKey: Keys.curve)
        try container.encode(isTestnet, forKey: Keys.testnet)

        if case .cardano(let extended) = self {
            try container.encode(extended, forKey: Keys.extended)
        }
    }
}

// MARK: - Helpers
@available(iOS 13.0, *)
extension Blockchain {
    public var decimalValue: Decimal {
        return pow(Decimal(10), decimalCount)
    }
}

// MARK: - Card's factory
@available(iOS 13.0, *)
extension Blockchain {
    public static func from(blockchainName: String, curve: EllipticCurve) -> Blockchain? {
        let testnetAttribute = "/test"
        let isTestnet = blockchainName.contains(testnetAttribute)
        let cleanName = blockchainName.remove(testnetAttribute).lowercased()
        switch cleanName {
        case "btc": return .bitcoin(testnet: isTestnet)
        case "xlm", "asset", "xlm-tag": return .stellar(curve: curve, testnet: isTestnet)
        case "eth", "token", "nfttoken": return .ethereum(testnet: isTestnet)
        case "ltc": return .litecoin
        case "rsk", "rsktoken": return .rsk
        case "bch": return .bitcoinCash
        case "binance", "binanceasset": return .binance(testnet: isTestnet)
            // For old cards cardano will work like ed25519_slip0010
        case "cardano", "cardano-s": return .cardano(extended: false)
        case "xrp": return .xrp(curve: curve)
        case "duc": return .ducatus
        case "xtz": return .tezos(curve: curve)
        case "doge": return .dogecoin
        case "bsc": return .bsc(testnet: isTestnet)
        // DO NOT ADD new blockchains here. This is legacy code and used only for Tangem Note and cards release before 4.12 firmware
        default: return nil
        }
    }
}

// MARK: - ID

private extension Blockchain {
    func id(type: IDType) -> String {
        switch self {
        case .bitcoin: return "bitcoin"
        case .litecoin: return "litecoin"
        case .stellar: return "stellar"
        case .ethereum: return "ethereum"
        case .ethereumPoW: return "ethereum-pow-iou"
        case .disChain: return "ethereumfair" // keep existing id for compatibility
        case .ethereumClassic: return "ethereum-classic"
        case .rsk: return "rootstock"
        case .bitcoinCash: return "bitcoin-cash"
        case .binance: return "binancecoin"
        case .cardano: return "cardano"
        case .xrp:
            switch type {
            case .network: return "xrp"
            case .coin: return "ripple"
            }
        case .ducatus: return "ducatus"
        case .tezos: return "tezos"
        case .dogecoin: return "dogecoin"
        case .bsc:
            switch type {
            case .network: return "binance-smart-chain"
            case .coin: return "binancecoin"
            }
        case .polygon:
            switch type {
            case .network: return "polygon-pos"
            case .coin: return "matic-network"
            }
        case .avalanche:
            switch type {
            case .network: return "avalanche"
            case .coin: return "avalanche-2"
            }
        case .solana: return "solana"
        case .fantom: return "fantom"
        case .polkadot: return "polkadot"
        case .kusama: return "kusama"
        case .azero: return "aleph-zero"
        case .tron: return "tron"
        case .arbitrum: return "arbitrum-one"
        case .dash: return "dash"
        case .gnosis: return "xdai"
        case .optimism: return "optimistic-ethereum"
        case .ton: return "the-open-network"
        case .kava: return "kava"
        case .kaspa: return "kaspa"
        case .ravencoin: return "ravencoin"
        case .cosmos: return "cosmos"
        case .terraV1:
            switch type {
            case .network: return "terra"
            case .coin: return "terra-luna"
            }
        case .terraV2:
            switch type {
            case .network: return "terra-2"
            case .coin: return "terra-luna-2"
            }
        case .cronos:
            switch type {
            case .network: return "cronos"
            case .coin: return "crypto-com-chain"
            }
        case .telos: return "telos"
        case .octa: return "octaspace"
        case .chia: return "chia"
        case .near:
            switch type {
            case .network: return "near-protocol"
            case .coin: return "near"
            }
        case .decimal:
            return "decimal"
        case .veChain:
            return "vechain"
        case .xdc:
            switch type {
            case .network: return "xdc-network"
            case .coin: return "xdce-crowd-sale"
            }
        case .algorand: return "algorand"
        case .shibarium:
            switch type {
            case .network: return "shibarium"
            case .coin: return "bone-shibaswap"
            }
        case .aptos:
            return "aptos"
        case .hedera:
            return "hedera-hashgraph"
        case .areon:
            return "areon-network"
        case .playa3ullGames:
            switch type {
            case .network: return "playa3ull-games"
            case .coin: return "playa3ull-games-2"
            }
        case .pulsechain:
            return "pulsechain"
        case .aurora:
            switch type {
            case .network: return "aurora"
            case .coin: return "aurora-ethereum"
            }
        case .manta:
            switch type {
            case .network: return "manta-network"
            case .coin: return "manta-network-ethereum"
            }
        case .zkSync:
            switch type {
            case .network: return "zksync"
            case .coin: return "zksync-ethereum"
            }
        case .moonbeam:
            return "moonbeam"
        case .polygonZkEVM:
            switch type {
            case .network: return "polygon-zkevm"
            case .coin: return "polygon-zkevm-ethereum"
            }
        case .moonriver:
            return "moonriver"
        case .mantle:
            return "mantle"
        case .flare:
            switch type {
            case .network: return "flare-network"
            case .coin: return "flare-networks"
            }
        case .taraxa:
            return "taraxa"
        case .radiant:
            return "radiant"
        case .base:
            switch type {
            case .network: return "base"
            case .coin: return "base-ethereum"
            }
        }
    }

    enum IDType: Hashable {
        case network
        case coin
    }
}

// MARK: - Assembly type

@available(iOS 13.0, *)
extension Blockchain {
    var assembly: WalletManagerAssembly {
        switch self {
        case .bitcoin:
            return BitcoinWalletAssembly()
        case .litecoin:
            return LitecoinWalletAssembly()
        case .dogecoin:
            return DogecoinWalletAssembly()
        case .ducatus:
            return DucatusWalletAssembly()
        case .stellar:
            return StellarWalletAssembly()
        case .ethereum,
                .ethereumClassic,
                .rsk,
                .bsc,
                .polygon,
                .avalanche,
                .fantom,
                .arbitrum,
                .gnosis,
                .ethereumPoW,
                .disChain,
                .kava,
                .cronos,
                .octa,
                .shibarium,
                .areon,
                .playa3ullGames,
                .pulsechain,
                .aurora,
                .zkSync,
                .moonbeam,
                .polygonZkEVM,
                .moonriver,
                .mantle,
                .flare,
                .taraxa:
            return EthereumWalletAssembly()
        case .optimism,
             .manta,
             .base:
            return EthereumOptimisticRollupWalletAssembly()
        case .bitcoinCash:
            return BitcoinCashWalletAssembly()
        case .binance:
            return BinanceWalletAssembly()
        case .cardano:
            return CardanoWalletAssembly()
        case .xrp:
            return XRPWalletAssembly()
        case .tezos:
            return TezosWalletAssembly()
        case .solana:
            return SolanaWalletAssembly()
        case .polkadot, .kusama, .azero:
            return SubstrateWalletAssembly()
        case .tron:
            return TronWalletAssembly()
        case .dash:
            return DashWalletAssembly()
        case .ton:
            return TONWalletAssembly()
        case .kaspa:
            return KaspaWalletAssembly()
        case .ravencoin:
            return RavencoinWalletAssembly()
        case .cosmos, .terraV1, .terraV2:
            return CosmosWalletAssembly()
        case .chia:
            return ChiaWalletAssembly()
        case .near:
            return NEARWalletAssembly()
        case .telos:
            return TelosWalletAssembly()
        case .decimal:
            return DecimalWalletAssembly()
        case .veChain:
            return VeChainWalletAssembly()
        case .xdc:
            return XDCWalletAssembly()
        case .algorand:
            return AlgorandWalletAssembly()
        case .aptos:
            return AptosWalletAssembly()
        case .hedera:
            return HederaWalletAssembly()
        case .radiant:
            return RadiantWalletAssembly()
        }
    }
}
