//
//  Token.swift
//  BlockchainSdk
//
//  Created by Alexander Osokin on 13.04.2020.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

public struct Token: Hashable, Equatable, Codable {
    public let name: String
    public let symbol: String
    public let contractAddress: String
    public let decimalCount: Int
    
    public init(name: String? = nil, symbol: String, contractAddress: String, decimalCount: Int) {
        self.name = name ?? symbol
        self.symbol = symbol
        self.contractAddress = contractAddress
        self.decimalCount = decimalCount
    }
}
