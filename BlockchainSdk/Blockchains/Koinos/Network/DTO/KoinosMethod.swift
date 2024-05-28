//
//  KoinosMethod.swift
//  BlockchainSdk
//
//  Created by Aleksei Muraveinik on 27.05.24.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation

enum KoinosMethod {}

extension KoinosMethod {
    enum ReadContract {
        struct RequestParams: Codable {
            let contractId: String
            let entryPoint: Int
            let args: String
        }
        
        struct Response: Codable {
            let result: String?
        }
    }
}

extension KoinosMethod {
    enum GetAccountRC {
        struct RequestParams: Codable {
            let account: String
        }
        
        struct Response: Codable {
            let rc: UInt64
        }
    }
}

extension KoinosMethod {
    enum GetAccountNonce {
        struct RequestParams: Codable {
            let account: String
        }
        
        struct Response: Codable {
            let nonce: UInt64
            
            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let base64EncodedNonce: String = try container.decode(forKey: .nonce)
                guard let stringNonce = base64EncodedNonce.base64Decoded(),
                      let nonce = UInt64(stringNonce)
                else {
                    throw WalletError.failedToParseNetworkResponse
                }
                self.nonce = nonce
            }
        }
    }
}

extension KoinosMethod {
    enum GetResourceLimits {
        struct Response: Codable {
            let resourceLimitData: KoinosChain.ResourceLimitData
        }
    }
}

extension KoinosMethod {
    enum SubmitTransaction {
        struct RequestParams: Codable {
            let transaction: KoinosProtocol.Transaction
            let broadcast: Bool
        }
        
        struct Response: Codable {
            let receipt: KoinosProtocol.TransactionReceipt
        }
    }
    
}
