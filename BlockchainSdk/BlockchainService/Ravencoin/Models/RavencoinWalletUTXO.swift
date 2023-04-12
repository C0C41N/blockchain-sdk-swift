//
//  RavencoinWalletUTXO.swift
//  BlockchainSdk
//
//  Created by Sergey Balashov on 03.04.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation

struct RavencoinWalletUTXO: Decodable {
    let txid: String
    let vout: Int
    let satoshis: UInt64
    let scriptPubKey: String
    let address: String?
    let assetName: String?
    let amount: Decimal?
    let height: Int?
    let confirmations: Int?
}
