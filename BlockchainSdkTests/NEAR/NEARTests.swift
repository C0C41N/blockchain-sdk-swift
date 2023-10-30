//
//  NEARTests.swift
//  BlockchainSdkTests
//
//  Created by Andrey Fedorov on 28.10.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation
import XCTest
import class WalletCore.PrivateKey
import enum WalletCore.Curve

@testable import BlockchainSdk

final class NEARTests: XCTestCase {
    // Using example values from https://nomicon.io/DataStructures/Account#examples
    func testAddressUtilImplicitAccountsDetection() {
        XCTAssertTrue(NEARAddressUtil.isImplicitAccount(accountId: "f69cd39f654845e2059899a888681187f2cda95f29256329aea1700f50f8ae86"))
        XCTAssertTrue(NEARAddressUtil.isImplicitAccount(accountId: "75149e81ac9ea0bcb6f00faee922f71a11271f6cbc55bac97753603504d7bf27"))
        XCTAssertTrue(NEARAddressUtil.isImplicitAccount(accountId: "64acf5e86c840024032d7e75ec569a4d304443e250b197d5a0246d2d49afc8e1"))
        XCTAssertTrue(NEARAddressUtil.isImplicitAccount(accountId: "84a3fe2fc0e585d802cfa160807d1bf8ca5f949cf8d04d128bf984c50aabab7b"))
        XCTAssertTrue(NEARAddressUtil.isImplicitAccount(accountId: "d85d322043d87cc475d3523d6fb0c3df903d3830e5d4d5027ffe565e7b8652bb"))

        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "f69cd39f654845e2059899a88868.1187f2cda95f29256329aea1700f50f8ae8"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "something.near"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: ""))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "6f8a1e9b0c2d3f4a5b7e8d9a1c32ed5f67b8cd0e1f23b4c5d6e7f88023a"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "9a4b6c1e2d8f3a5b7e8d9a1c3b2e4d5f6a7b8c9d0e1f2a3b4c5d6e7f8a4b6c1e2d8f3"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "ctiud11caxsb2tw7dmfcrhfw9ah15ltkydrjfblst32986pekmb3dsvyrmyym6qn"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "ok"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "bowen"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "ek-2"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "ek.near"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "com"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "google.com"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "bowen.google.com"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "near"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "illia.cheap-accounts.near"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "max_99.near"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "100"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "near2019"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "over.9000"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "a.bro"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "bro.a"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "not ok"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "a"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "100-"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "bo__wen"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "_illia"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: ".near"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "near."))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "a..near"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "$$$"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "WAT"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "me@google.com"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "system"))
        XCTAssertFalse(NEARAddressUtil.isImplicitAccount(accountId: "abcdefghijklmnopqrstuvwxyz.abcdefghijklmnopqrstuvwxyz.abcdefghijklmnopqrstuvwxyz"))
    }

    // Using example values from https://nomicon.io/DataStructures/Account#examples
    func testAddressUtilNamedAccountValidation() {
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "f69cd39f654845e2059899a888681187f2cda95f29256329aea1700f50f8ae86"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "f69cd39f654845e2059899a88868.1187f2cda95f29256329aea1700f50f8ae8"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "something.near"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "6f8a1e9b0c2d3f4a5b7e8d9a1c32ed5f67b8cd0e1f23b4c5d6e7f88023a"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "ctiud11caxsb2tw7dmfcrhfw9ah15ltkydrjfblst32986pekmb3dsvyrmyym6qn"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "ok"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "bowen"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "ek-2"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "ek.near"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "com"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "google.com"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "bowen.google.com"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "near"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "illia.cheap-accounts.near"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "max_99.near"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "100"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "near2019"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "over.9000"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "a.bro"))
        XCTAssertTrue(NEARAddressUtil.isValidNamedAccount(accountId: "bro.a"))

        XCTAssertFalse(NEARAddressUtil.isValidNamedAccount(accountId: ""))
        XCTAssertFalse(NEARAddressUtil.isValidNamedAccount(accountId: "9a4b6c1e2d8f3a5b7e8d9a1c3b2e4d5f6a7b8c9d0e1f2a3b4c5d6e7f8a4b6c1e2d8f3"))
        XCTAssertFalse(NEARAddressUtil.isValidNamedAccount(accountId: "not ok"))
        XCTAssertFalse(NEARAddressUtil.isValidNamedAccount(accountId: "a"))
        XCTAssertFalse(NEARAddressUtil.isValidNamedAccount(accountId: "100-"))
        XCTAssertFalse(NEARAddressUtil.isValidNamedAccount(accountId: "bo__wen"))
        XCTAssertFalse(NEARAddressUtil.isValidNamedAccount(accountId: "_illia"))
        XCTAssertFalse(NEARAddressUtil.isValidNamedAccount(accountId: ".near"))
        XCTAssertFalse(NEARAddressUtil.isValidNamedAccount(accountId: "near."))
        XCTAssertFalse(NEARAddressUtil.isValidNamedAccount(accountId: "a..near"))
        XCTAssertFalse(NEARAddressUtil.isValidNamedAccount(accountId: "$$$"))
        XCTAssertFalse(NEARAddressUtil.isValidNamedAccount(accountId: "WAT"))
        XCTAssertFalse(NEARAddressUtil.isValidNamedAccount(accountId: "me@google.com"))
        XCTAssertFalse(NEARAddressUtil.isValidNamedAccount(accountId: "system"))
        XCTAssertFalse(NEARAddressUtil.isValidNamedAccount(accountId: "abcdefghijklmnopqrstuvwxyz.abcdefghijklmnopqrstuvwxyz.abcdefghijklmnopqrstuvwxyz"))
    }

    // TODO: Andrey Fedorov - Do both `ed25519` and `ed25519_slip0010` curves need to be tested?
    func testSigningTransactionEd25519() throws {
        let blockchain: Blockchain = .near(curve: .ed25519, testnet: false)
        try testSigningTransaction(blockchain: blockchain)
    }

    // TODO: Andrey Fedorov - Do both `ed25519` and `ed25519_slip0010` curves need to be tested?
    func testSigningTransactionEd25519Slip0010() throws {
        let blockchain: Blockchain = .near(curve: .ed25519_slip0010, testnet: false)
        try testSigningTransaction(blockchain: blockchain)
    }

    // Constants are taken from TrustWalletCore's `NEARTests.swift`
    private func testSigningTransaction(blockchain: Blockchain) throws {
        let privateKeyData = "3hoMW1HvnRLSFCLZnvPzWeoGwtdHzke34B2cTHM8rhcbG3TbuLKtShTv3DvyejnXKXKBiV7YPkLeqUHN1ghnqpFv"
            .base58DecodedData[0..<32]
        let privateKey = try XCTUnwrap(PrivateKey(data: privateKeyData))

        let publicKeyData = privateKey.getPublicKeyEd25519().data
        let publicKey = Wallet.PublicKey(seedKey: publicKeyData, derivationType: nil)

        let addressServiceFactory = AddressServiceFactory(blockchain: blockchain)
        let addressService = addressServiceFactory.makeAddressService()
        let sourceAddress = "test.near"
        let destinationAddress = "whatever.near"

        let value = 1.0 / blockchain.decimalValue   // 1 yoctoNEAR, 1 * 10^-24
        let amount = Amount(with: blockchain, value: value)
        let fee = Fee(.dummyCoin(for: blockchain))  // Isn't included in the transaction, therefore a dummy value is used

        let transactionParams = NEARTransactionParams(
            publicKey: publicKey,
            currentNonce: 1,
            recentBlockHash: "244ZQ9cgj3CQ6bWBdytfrJMuMQ1jdXLFGnr4HhvtCTnM"
        )

        let transaction = Transaction(
            amount: amount,
            fee: fee,
            sourceAddress: sourceAddress,
            destinationAddress: destinationAddress,
            changeAddress: sourceAddress
        ).then { $0.params = transactionParams }

        let transactionBuilder = NEARTransactionBuilder(blockchain: blockchain)

        let transactionHash = try transactionBuilder.buildForSign(transaction: transaction)

        let transactionSignature = try XCTUnwrap(
            privateKey.sign(
                digest: transactionHash,
                curve: try Curve(blockchain: blockchain)
            )
        )

        let signedTransaction = try transactionBuilder.buildForSend(
            transaction: transaction,
            signature: transactionSignature
        )

        let base64EncodedTransaction = signedTransaction.base64EncodedString()

        let expectedBase64EncodedTransaction = """
CQAAAHRlc3QubmVhcgCRez0mjUtY9/7BsVC9aNab4+5dTMOYVeNBU4Rlu3eGDQEAAAAAAAAADQAAAHdoYXRldmVyLm5lYX\
IPpHP9JpAd8pa+atxMxN800EDvokNSJLaYaRDmMML+9gEAAAADAQAAAAAAAAAAAAAAAAAAAACWmoMzIYbul1Xkg5MlUlgG4\
Ymj0tK7S0dg6URD6X4cTyLe7vAFmo6XExAO2m4ZFE2n6KDvflObIHCLodjQIb0B
"""

        XCTAssertEqual(base64EncodedTransaction, expectedBase64EncodedTransaction)
    }
}
