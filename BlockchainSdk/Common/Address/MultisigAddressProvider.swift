//
//  MultisigAddressProvider.swift
//  BlockchainSdk
//
//  Created by Sergey Balashov on 31.05.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation

public protocol MultisigAddressProvider {
    func makeAddresses(from walletPublicKey: Data, with pairPublicKey: Data) throws -> [Address]
}