//
//  TronNetwork.swift
//  BlockchainSdk
//
//  Created by Andrey Chukavin on 24.03.2022.
//  Copyright © 2022 Tangem AG. All rights reserved.
//

import Foundation

enum TronNetwork {
    case nowNodes(apiKey: String)
    case getBlock(apiKey: String)
    case mainnet(apiKey: String?)
    case shasta
    case nile
    
    var url: URL {
        switch self {
        case .nowNodes(let apiKey):
            return URL(string: "https://trx.nownodes.io/\(apiKey)")!
        case .getBlock(let apiKey):
            return URL(string: "https://trx.getblock.io/mainnet/\(apiKey)")!
        case .mainnet:
            return URL(string: "https://api.trongrid.io")!
        case .shasta:
            return URL(string: "https://api.shasta.trongrid.io/")!
        case .nile:
            return URL(string: "https://nile.trongrid.io")!
        }
    }
    
    var apiKeyHeaderValue: String? {
        if case .mainnet(let apiKey) = self {
            return apiKey
        } else {
            return nil
        }
    }
    
    var apiKeyHeaderName: String? {
        if case .mainnet = self {
            return "TRON-PRO-API-KEY"
        } else {
            return nil
        }
    }
}
