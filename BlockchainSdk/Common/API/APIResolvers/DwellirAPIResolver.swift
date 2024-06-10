//
//  DwellirAPIResolver.swift
//  BlockchainSdk
//
//  Created by Dmitry Fedorov on 10.06.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation

struct DwellirAPIResolver {
    let config: BlockchainSdkConfig
    
    func resolve(blockchain: Blockchain) -> NodeInfo? {
        guard
            case .bittensor = blockchain,
            let url = URL(string: "https://api-bittensor-mainnet.dwellir.com/\(config.bittensorDwellirKey)/")
        else {
            return nil
        }

        return .init(url: url)
    }
}
