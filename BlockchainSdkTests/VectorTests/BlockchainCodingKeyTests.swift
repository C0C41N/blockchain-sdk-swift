//
//  BlockchainCodingKeyTests.swift
//  BlockchainSdkTests
//
//  Created by skibinalexander on 25.04.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import XCTest
import CryptoKit
import TangemSdk
import WalletCore

@testable import BlockchainSdk

class BlockchainCodingKeyTests: XCTestCase {
    let testVectorsUtility = TestVectorsUtility()
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
}

// MARK: - Compare Addresses from address string

@available(iOS 13.0, *)
extension BlockchainCodingKeyTests {
    
    func testCodingKeys() {
        do {
            guard let blockchains: [BlockchainSdk.Blockchain] = try testVectorsUtility.getTestVectors(from: "blockchain_vectors") else {
                XCTFail("__INVALID_VECTOR__ BLOCKCHAIN DATA IS NIL")
                return
            }
            
            for blockchain in blockchains {
                let recoveredFromCodable = try? decoder.decode(Blockchain.self, from: try encoder.encode(blockchain))
                XCTAssertTrue(recoveredFromCodable == blockchain, "\(blockchain.displayName) codingKey test failed")
            }
        } catch let error {
            XCTFail("__INVALID_VECTOR__ \(error)")
            return
        }
    }
    
}
