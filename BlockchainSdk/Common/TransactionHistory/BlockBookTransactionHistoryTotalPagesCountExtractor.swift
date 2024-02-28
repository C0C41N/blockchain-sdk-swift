//
//  BlockBookTransactionHistoryTotalPagesCountExtractor.swift
//  BlockchainSdk
//
//  Created by Andrey Fedorov on 29.02.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation

protocol BlockBookTransactionHistoryTotalPagesCountExtractor {
    func extractTotalPagesCount(from response: BlockBookAddressResponse, contractAddress: String?) throws -> Int
}
