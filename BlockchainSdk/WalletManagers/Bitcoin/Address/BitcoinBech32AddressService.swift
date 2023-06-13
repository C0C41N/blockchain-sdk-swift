//
//  BitcoinBech32AddressService.swift
//  BlockchainSdk
//
//  Created by Sergey Balashov on 06.06.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation
import BitcoinCore
import TangemSdk

@available(iOS 13.0, *)
public class BitcoinBech32AddressService {
    private let converter: SegWitBech32AddressConverter

    init(networkParams: INetwork) {
        let scriptConverter = ScriptConverter()
        converter = SegWitBech32AddressConverter(prefix: networkParams.bech32PrefixPattern, scriptConverter: scriptConverter)
    }

    public func validate(_ address: String) -> Bool {
        do {
            _ = try converter.convert(address: address)
            return true
        } catch {
            return false
        }
    }

    public func makeMultisigAddress(from scriptHash: Data) throws -> String {
        let address = try converter.convert(scriptHash: scriptHash).stringValue

        return address
    }
}

@available(iOS 13.0, *)
extension BitcoinBech32AddressService: AddressProvider {
    public func makeAddress(for publicKey: Wallet.PublicKey, with addressType: AddressType) throws -> AddressPublicKeyPair {
        let compressedKey = try Secp256k1Key(with: publicKey.blockchainKey).compress()
        let bitcoinCorePublicKey = PublicKey(withAccount: 0,
                                  index: 0,
                                  external: true,
                                  hdPublicKeyData: compressedKey)

        let address = try converter.convert(publicKey: bitcoinCorePublicKey, type: .p2wpkh).stringValue
        return AddressPublicKeyPair(value: address, publicKey: publicKey, type: addressType)
    }
}
