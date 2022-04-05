//
//  BlockchairTarget.swift
//  BlockchainSdk
//
//  Created by Alexander Osokin on 14.02.2020.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import Moya

enum BlockchairEndpoint {
    case bitcoin(testnet: Bool),
         bitcoinCash,
         litecoin,
         dogecoin,
         ethereum(testnet: Bool)
    
    var path: String {
        switch self {
        case .bitcoin(let testnet): return "bitcoin" + (testnet ? "/testnet" : "")
        case .bitcoinCash: return "bitcoin-cash"
        case .litecoin: return "litecoin"
        case .dogecoin: return "dogecoin"
        case .ethereum(let testnet): return "ethereum" + (testnet ? "/testnet" : "")
        }
    }
    
    var blockchain: Blockchain {
        switch self {
        case .bitcoin(let testnet):
            return .bitcoin(testnet: testnet)
        case .bitcoinCash:
            return .bitcoinCash(testnet: false)
		case .litecoin:
			return .litecoin
        case .ethereum(let testnet):
            return .ethereum(testnet: testnet)
        case .dogecoin:
            return .dogecoin
        }
    }
}

struct BlockchairTarget: TargetType {
    enum BlockchairTargetType {
        case address(address: String, endpoint: BlockchairEndpoint, transactionDetails: Bool)
        case fee(endpoint: BlockchairEndpoint)
        case send(txHex: String, endpoint: BlockchairEndpoint)

        case txDetails(txHash: String, endpoint: BlockchairEndpoint)
        case txsDetails(hashes: [String], endpoint: BlockchairEndpoint)
        case findErc20Tokens(address: String, endpoint: BlockchairEndpoint)
    }
    
    let type: BlockchairTargetType
    let apiKey: String?
    
    var baseURL: URL {
        var endpointString = ""
        
        switch type {
        case .address(_, let endpoint, _):
            endpointString = endpoint.path
        case .fee(let endpoint):
            endpointString = endpoint.path
        case .send(_, let endpoint):
            endpointString = endpoint.path
        case .txDetails(_, let endpoint):
            endpointString = endpoint.path
        case .txsDetails(_, let endpoint):
            endpointString = endpoint.path
        case .findErc20Tokens(_, let endpoint):
            endpointString = endpoint.path
        }
        
        return URL(string: "https://api.blockchair.com/\(endpointString)")!
    }
    
    var path: String {
        switch type {
        case .address(let address, _, _):
            return "/dashboards/address/\(address)"
        case .fee:
            return "/stats"
        case .send:
            return "/push/transaction"
        case .txDetails(let hash, _):
            return "/dashboards/transaction/\(hash)"
        case .txsDetails(let hashes, _):
            var path = "/dashboards/transactions/"
            if !hashes.isEmpty {
                hashes.forEach {
                    path.append($0)
                    path.append(",")
                }
                path.removeLast()
            }
            return path
        
        case .findErc20Tokens(let address, _):
            return "/dashboards/address/\(address)"
        }
    }
    
    var method: Moya.Method {
        switch type {
        case .address, .fee, .txDetails, .txsDetails, .findErc20Tokens:
            return .get
        case .send:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        var parameters = [String:String]()

        if let apiKey = apiKey {
            parameters["key"] = apiKey
        }

        switch type {
        case .address(_, _, let details):
            parameters["transaction_details"] = "\(details)"
        case .fee(_):
            break
        case .send(let txHex, _):
            parameters["data"] = txHex
        case .txDetails(_, _), .txsDetails(_, _):
            break
        case .findErc20Tokens(_, _):
            parameters["erc_20"] = "true"
        }
        
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String: String]? {
        switch type {
        case .address, .fee, .txDetails, .txsDetails, .findErc20Tokens:
            return ["Content-Type": "application/json"]
        case .send:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
}
