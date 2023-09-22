//
//  ERC20TokenMethodType.swift
//  BlockchainSdk
//
//  Created by Sergey Balashov on 15.09.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation

/// https://eips.ethereum.org/EIPS/eip-20
public protocol SmartContractMethod {
    var prefix: String { get }
    var data: Data { get }
}
