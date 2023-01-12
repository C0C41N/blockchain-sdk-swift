//
//  TONTests.swift
//  BlockchainSdkTests
//
//  Created by skibinalexander on 12.01.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import XCTest
import BigInt
@testable import BlockchainSdk

class TONTests: XCTestCase {
    private let addressService = TONAddressService()
    private let blockchain = Blockchain.ethereum(testnet: false)
    private let gasLimit = BigUInt(21000)
    private let sizeTester = TransactionSizeTesterUtility()
    
    func testAddress() {
        
    }
    
    func testValidateCorrectAddress() {
        
    }
    
    func testValidateCorrectAddressWithChecksum() {
        
    }
    
    func testBuildCoorectCoinTransaction() {
        
    }
    
    func testBuildCorrectTokenTransaction() {
        
    }
    
    func testParseBalance() {
        
    }
}
