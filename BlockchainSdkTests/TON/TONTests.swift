//
//  TONTests.swift
//  BlockchainSdkTests
//
//  Created by skibinalexander on 20.03.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import XCTest
import CryptoKit
import TangemSdk
import WalletCore

@testable import BlockchainSdk

class TONTests: XCTestCase {
    
    private var blockchain = Blockchain.ton(testnet: true)
    private var privateKey = try! Curve25519.Signing.PrivateKey(
        rawRepresentation: Data(hexString: "0x85fca134b3fe3fd523d8b528608d803890e26c93c86dc3d97b8d59c7b3540c97")
    )
    
    lazy var walletManager: TONWalletManager = {
        let walletPubKey = privateKey.publicKey.rawRepresentation
        let address = try! blockchain.makeAddresses(from: walletPubKey, with: nil)
        
        let wallet = Wallet(
            blockchain: blockchain,
            addresses: address,
            publicKey: .init(
                seedKey: walletPubKey,
                derivedKey: nil,
                derivationPath: nil
            )
        )
        
        return try! .init(
            wallet: wallet,
            networkService: TONNetworkService(providers: [], blockchain: blockchain)
        )
    }()
    
    lazy var txBuilder: TONTransactionBuilder = {
        return TONTransactionBuilder.makeDummyBuilder(
            with: .init(
                wallet: walletManager.wallet,
                inputPrivateKey: privateKey,
                sequenceNumber: 0
            )
        )
    }()
    
    func testCorrectCoinTransaction() {
        do {
            let input = try txBuilder.buildForSign(
                amount: .init(with: blockchain, value: 1),
                destination: "EQAoDMgtvyuYaUj-iHjrb_yZiXaAQWSm4pG2K7rWTBj9eOC2",
                memo: .none
            )
            
            XCTAssertEqual(try! input.jsonString(), "{\"privateKey\":\"hfyhNLP+P9Uj2LUoYI2AOJDibJPIbcPZe41Zx7NUDJc=\",\"transfer\":{\"walletVersion\":\"WALLET_V4_R2\",\"dest\":\"EQAoDMgtvyuYaUj-iHjrb_yZiXaAQWSm4pG2K7rWTBj9eOC2\",\"amount\":\"1000000000\",\"mode\":3,\"bounceBehavior\":\"NON_BOUNCEABLE\"}}"
            )
            
            let output = try walletManager.buildTransaction(
                input: input,
                with: TrustCoreSignerTesterUtility(
                    privateKey: privateKey,
                    signatures: [
                        Data(hex: "0c88f60571fae5ae341b1af5910e0c07bd5676726cd7775c85159b5542cecb0c5e3f291d5f69f4f2da012524211c064ec2fc5f7f0c62b1ea236d6165d1fc2c09")
                    ]
                )
            )
            
            XCTAssertEqual(output, "te6ccgICABoAAQAAA84AAAJFiAAkFwRyHvf/dUy7kDH1X6DgWJwTOQ0gSoVCd0RKy2RgfB4ABAABAZwMiPYFcfrlrjQbGvWRDgwHvVZ2cmzXd1yFFZtVQs7LDF4/KR1fafTy2gElJCEcBk7C/F9/DGKx6iNtYWXR/CwJKamjF/////8AAAAAAAMAAgFoQgAUBmQW35XMNKR/RDx1t/5MxLtAILJTcUjbFd1rJgx+vCHc1lAAAAAAAAAAAAAAAAAAAQADAAACATQABgAFAFEAAAAAKamjF+Cz/Mz+AoPMD4wQXGi1aQqrjFwWkqho5V6sqDbId5CFQAEU/wD0pBP0vPLICwAHAgEgAA0ACAT48oMI1xgg0x/TH9MfAvgju/Jk7UTQ0x/TH9P/9ATRUUO68qFRUbryogX5AVQQZPkQ8qP4ACSkyMsfUkDLH1Iwy/9SEPQAye1U+A8B0wchwACfbFGTINdKltMH1AL7AOgw4CHAAeMAIcAC4wABwAORMOMNA6TIyx8Syx/L/wAMAAsACgAJAAr0AMntVABsgQEI1xj6ANM/MFIkgQEI9Fnyp4IQZHN0cnB0gBjIywXLAlAFzxZQA/oCE8tqyx8Syz/Jc/sAAHCBAQjXGPoA0z/IVCBHgQEI9FHyp4IQbm90ZXB0gBjIywXLAlAGzxZQBPoCFMtqEssfyz/Jc/sAAgBu0gf6ANTUIvkABcjKBxXL/8nQd3SAGMjLBcsCIs8WUAX6AhTLaxLMzMlz+wDIQBSBAQj0UfKnAgIBSAAXAA4CASAAEAAPAFm9JCtvaiaECAoGuQ+gIYRw1AgIR6STfSmRDOaQPp/5g3gSgBt4EBSJhxWfMYQCASAAEgARABG4yX7UTQ1wsfgCAVgAFgATAgEgABUAFAAZrx32omhAEGuQ64WPwAAZrc52omhAIGuQ64X/wAA9sp37UTQgQFA1yH0BDACyMoHy//J0AGBAQj0Cm+hMYALm0AHQ0wMhcbCSXwTgItdJwSCSXwTgAtMfIYIQcGx1Z70ighBkc3RyvbCSXwXgA/pAMCD6RAHIygfL/8nQ7UTQgQFA1yH0BDBcgQEI9ApvoTGzkl8H4AXTP8glghBwbHVnupI4MOMNA4IQZHN0crqSXwbjDQAZABgAilAEgQEI9Fkw7UTQgQFA1yDIAc8W9ADJ7VQBcrCOI4IQZHN0coMesXCAGFAFywVQA88WI/oCE8tqyx/LP8mAQPsAkl8D4gB4AfoA9AQw+CdvIjBQCqEhvvLgUIIQcGx1Z4MesXCAGFAEywUmzxZY+gIZ9ADLaRfLH1Jgyz8gyYBA+wAG")
        } catch {
            XCTFail("Transaction build for sign is nil")
        }
    }
    
}
