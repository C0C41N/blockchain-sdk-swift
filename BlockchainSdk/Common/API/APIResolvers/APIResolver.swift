//
//  APIResolver.swift
//  BlockchainSdk
//
//  Created by Andrew Son on 04/04/24.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation

struct APIResolver {
    let blockchain: Blockchain
    let config: BlockchainSdkConfig

    func resolveProviders<T>(apiInfos: [APIInfo], factory: (NodeInfo, APIInfo?) -> T?) -> [T] {
        if blockchain.isTestnet {
            return TestnetAPINodeInfoProvider(blockchain: blockchain, config: config).urls()?.compactMap {
                factory($0, nil)
            } ?? []
        }

        let resolver = APINodeInfoResolver(blockchain: blockchain, config: config)
        return apiInfos.compactMap {
            guard let nodeInfo = resolver.resolve(for: $0) else {
                return nil
            }

            return factory(nodeInfo, $0)
        }
    }
}
