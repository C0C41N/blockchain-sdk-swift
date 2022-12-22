//
//  BlockBookService.swift
//  BlockchainSdk
//
//  Created by Andrey Chukavin on 20.12.2022.
//  Copyright © 2022 Tangem AG. All rights reserved.
//

import Foundation

enum BlockBookService {
    case nowNodes
    case getBlock
    
    var host: String {
        switch self {
        case .nowNodes:
            return "nownodes.io"
        case .getBlock:
            return "getblock.io"
        }
    }
    
    func domain(for request: BlockBookTarget.Request, blockchain: Blockchain) -> String {
        let currencySymbolPrefix = blockchain.currencySymbol.lowercased()
        
        switch request {
        case .fees:
            return "https://\(currencySymbolPrefix).\(host)"
        default:
            switch self {
            case .nowNodes:
                let testnetSuffix = blockchain.isTestnet ? "-testnet" : ""
                return "https://\(currencySymbolPrefix)book\(testnetSuffix).\(host)"
            case .getBlock:
                return "https://\(currencySymbolPrefix).\(host)"
            }
        }
    }
    
    func path(for request: BlockBookTarget.Request) -> String {
        switch request {
        case .fees:
            switch self {
            case .nowNodes:
                return ""
            case .getBlock:
                return "/mainnet"
            }
        default:
            switch self {
            case .nowNodes:
                return "/api/v2"
            case .getBlock:
                return "/mainnet/blockbook/api/v2"
            }
        }
    }
}
