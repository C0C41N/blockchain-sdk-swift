//
//  CryptoAPIsDataResponse.swift
//  BlockchainSdk
//
//  Created by Sergey Balashov on 10.06.2022.
//  Copyright © 2022 Tangem AG. All rights reserved.
//

import Foundation

struct CryptoAPIsDataResponse: Codable {
    let item: CryptoAPIsAddressResponse?
}

struct CryptoAPIsAddressResponse: Codable {
    let transactionsCount: Int?
    let confirmedBalance: CryptoAPIsAmount?
    let totalReceived: CryptoAPIsAmount?
    let totalSpent: CryptoAPIsAmount?
    let incomingTransactionsCount: Int?
    let outgoingTransactionsCount: Int?
}

struct CryptoAPIsAmount: Codable {
    let amount: String?
    let unit: String?
}
