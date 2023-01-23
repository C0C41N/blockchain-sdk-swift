//
//  TONTypes.swift
//  BlockchainSdk
//
//  Created by skibinalexander on 18.01.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation

enum AdressLen: Int {
    case b64UserFriendlyAddressLen = 48
    case userFriendlyAddressLen = 36
}

enum AddressTag : UInt8 {
    case BOUNCEABLE = 0x11
    case NON_BOUNCEABLE = 0x51
    case TEST_ONLY = 0x80
}
