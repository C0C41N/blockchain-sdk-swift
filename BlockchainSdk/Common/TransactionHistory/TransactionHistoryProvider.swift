//
//  TransactionHistoryProvider.swift
//  BlockchainSdk
//
//  Created by Sergey Balashov on 25.07.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation
import Combine

@available(iOS 13.0, *)
public protocol TransactionHistoryProvider {
    var canFetchHistory: Bool { get }
    var requestObjectDescription: CustomStringConvertible { get }
    
    func loadTransactionHistory(request: TransactionHistory.Request) -> AnyPublisher<TransactionHistory.Response, Error>
    func reset()
}
