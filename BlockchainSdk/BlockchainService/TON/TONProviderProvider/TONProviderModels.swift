//
//  TONProviderContent.swift
//  BlockchainSdk
//
//  Created by skibinalexander on 27.01.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation

/// TON provider content of Response
enum TONModels {
    
    /// Info state model
    struct Info: Codable {
        
        /// Is chain transaction wallet
        let wallet: Bool
        
        /// Balance in string value
        let balance: String
        
        /// State of wallet
        let accountState: AccountState
        
        /// Sequence number transations
        let seqno: Int?
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<TONModels.Info.CodingKeys> = try decoder.container(keyedBy: TONModels.Info.CodingKeys.self)
            self.wallet = try container.decode(Bool.self, forKey: TONModels.Info.CodingKeys.wallet)
            self.balance = try Self.mapBalance(from: decoder)
            self.accountState = try container.decode(TONModels.AccountState.self, forKey: TONModels.Info.CodingKeys.accountState)
            self.seqno = try container.decodeIfPresent(Int.self, forKey: TONModels.Info.CodingKeys.seqno)
        }
        
        // MARK: - Info Private Implementation
        
        private static func mapBalance(from decoder: Decoder) throws -> String {
            let container: KeyedDecodingContainer<TONModels.Info.CodingKeys> = try decoder.container(keyedBy: TONModels.Info.CodingKeys.self)
            let strValue = try? container.decode(String.self, forKey: TONModels.Info.CodingKeys.balance)
            let intValue = try? container.decode(Int.self, forKey: TONModels.Info.CodingKeys.balance)
            return strValue ?? String(intValue ?? 0)
        }
        
    }
    
    /// Fee agregate model
    struct Fee: Codable {
        
        /// Fees model
        let sourceFees: SourceFees
        
    }
    
    /// Response decode send boc model
    struct SendBoc: Codable {
        
        /// Transaction Hash 
        let hash: String
        
    }
    
    /// Sequence number model
    struct Seqno: Codable {
        
        /// Container seqno number
        let stack: [[Stack]]
        
    }

    
}

extension TONModels {
    
    enum AccountState: String, Codable {
        case active
        case uninitialized
    }
    
    struct SourceFees: Codable {
        
        /// Is a charge for importing messages from outside the blockchain.
        /// Every time you make a transaction, it must be delivered to the validators who will process it.
        let inFwdFee: Decimal
        
        /// Is the amount you pay for storing a smart contract in the blockchain.
        /// In fact, you pay for every second the smart contract is stored on the blockchain.
        let storageFee: Decimal
        
        /// Is the amount you pay for executing code in the virtual machine.
        /// The larger the code, the more fees must be paid.
        let gasFee: Decimal
        
        /// Stands for a charge for sending messages outside the TON
        let fwdFee: Decimal
        
        // MARK: - Helper
        
        var totalFee: Decimal {
            inFwdFee + storageFee + gasFee + fwdFee
        }
        
    }
    
    struct Stack: Codable {
        let num: String
    }
    
}
