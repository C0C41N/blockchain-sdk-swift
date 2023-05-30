//
//  BlockchainSdkError.swift
//  BlockchainSdk
//
//  Created by Andrew Son on 27/11/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

public enum BlockchainSdkError: Int, LocalizedError {
	case signatureCountNotMatched = 0
	case failedToCreateMultisigScript = 1
	case failedToConvertPublicKey = 2
	case notImplemented = -1000
    case decodingFailed
    case failedToLoadFee
    case failedToLoadTxDetails
    case failedToFindTransaction
    case failedToFindTxInputs
    case feeForPushTxNotEnough
    case networkProvidersNotSupportsRbf
    
    public var errorDescription: String? {
        switch self {
        case .failedToLoadFee:
            return "common_fee_error".localized
        case .signatureCountNotMatched, .notImplemented:
            // TODO: Replace with proper error message. Android sending instead of message just code, and client app decide what message to show to user
            return "generic_error_code".localized(errorCodeDescription)
		default:
			return "generic_error_code".localized(errorCodeDescription)
		}
	}
    
    private var errorCodeDescription: String {
        "blockchain_sdk_error \(rawValue)"
    }
}

public enum NetworkServiceError: Error {
    case notAvailable
}
