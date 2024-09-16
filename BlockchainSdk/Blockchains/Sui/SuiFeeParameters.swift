//
// SuiFeeParameters.swift
// BlockchainSdk
//
// Created by Sergei Iakovlev on 05.09.2024
// Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation


public struct SuiFeeParameters: FeeParameters {
    
    public var amount: Decimal {
       gasBudget 
    }
    
    public var gasPrice: Decimal
    public var gasBudget: Decimal
    
}
