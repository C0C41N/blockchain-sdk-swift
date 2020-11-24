//
//  StellarTransactionParams.swift
//  BlockchainSdk
//
//  Created by Alexander Osokin on 23.11.2020.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import stellarsdk

public enum StellarTransactionParams: TransactionParams {
    case memo(value: StellarMemo)
}

public typealias StellarMemo = Memo
