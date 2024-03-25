//
//  TransactionHistoryMapper.swift
//  BlockchainSdk
//
//  Created by Andrey Fedorov on 20.03.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation

protocol TransactionHistoryMapper {
    associatedtype Response

    func mapToTransactionRecords(
        _ response: Response,
        walletAddress: String,
        amountType: Amount.AmountType
    ) throws -> TransactionHistory.Response

    func reset()
}

// MARK: - Default implementation

extension TransactionHistoryMapper {
    func reset() {}
}
