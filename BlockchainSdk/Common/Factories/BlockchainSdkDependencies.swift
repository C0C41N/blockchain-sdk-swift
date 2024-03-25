//
//  BlockchainDependencies.swift
//  BlockchainSdk
//
//  Created by Andrey Fedorov on 12.02.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation

public struct BlockchainSdkDependencies {
    let accountCreator: any AccountCreator
    let dataStorage: any BlockchainDataStorage
    let blockchainAnalytics: any BlockchainAnalytics

    public init(
        accountCreator: any AccountCreator,
        dataStorage: any BlockchainDataStorage,
        blockchainAnalytics: any BlockchainAnalytics
    ) {
        self.accountCreator = accountCreator
        self.dataStorage = dataStorage
        self.blockchainAnalytics = blockchainAnalytics
    }
}
