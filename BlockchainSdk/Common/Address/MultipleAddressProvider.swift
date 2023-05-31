//
//  MultipleAddressProvider.swift
//  BlockchainSdk
//
//  Created by Alexander Osokin on 13.11.2020.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk

@available(*, deprecated, message: "Use AddressProvider.makeAddress(for:, with:)")
public protocol MultipleAddressProvider: AddressService {
    func makeAddresses(from walletPublicKey: Data) throws -> [Address]
}
