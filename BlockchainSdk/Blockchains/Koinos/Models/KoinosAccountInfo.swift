//
//  KoinosAccountInfo.swift
//  BlockchainSdk
//
//  Created by Aleksei Muraveinik on 29.05.24.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation

struct KoinosAccountInfo {
    let koinBalance: Decimal // TODO: [KOINOS] BigDecimal?
    let mana: Decimal // TODO: [KOINOS] BigDecimal?
    let maxMana: Decimal // TODO: [KOINOS] BigDecimal?
}
