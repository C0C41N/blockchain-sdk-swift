//
// SuiError.swift
// BlockchainSdk
//
// Created by Sergei Iakovlev on 30.08.2024
// Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation


public struct SuiError {
    
    public enum CoinType: Error {
        case failedEncoding
        case failedDecoding
    }
    
}
