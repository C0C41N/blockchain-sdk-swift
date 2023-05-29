//
//  HostProvider.swift
//  BlockchainSdk
//
//  Created by Sergey Balashov on 25.07.2022.
//  Copyright © 2022 Tangem AG. All rights reserved.
//

import Foundation

public protocol HostProvider {
    var host: String { get }
}
