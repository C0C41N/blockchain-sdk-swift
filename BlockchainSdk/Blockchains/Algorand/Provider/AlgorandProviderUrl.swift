//
//  AlgorandNetworkUrl.swift
//  BlockchainSdk
//
//  Created by skibinalexander on 10.01.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation

struct AlgorandProviderNode: HostProvider {
    let url: URL
    let apiKeyInfo: APIKeyInfo?

    var host: String {
        url.hostOrUnknown
    }
}
