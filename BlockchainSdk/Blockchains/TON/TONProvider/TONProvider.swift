//
//  TONProvider.swift
//  BlockchainSdk
//
//  Created by skibinalexander on 26.01.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation
import Combine
import BigInt

struct TONProvider: HostProvider {
    /// Blockchain API host
    var host: String {
        node.url.hostOrUnknown
    }
    
    /// Configuration connection node for provider
    private let node: NodeInfo

    // MARK: - Properties
    
    /// Network provider of blockchain
    private let network: NetworkProvider<TONProviderTarget>
    
    // MARK: - Init
    
    init(
        node: NodeInfo,
        networkConfig: NetworkProviderConfiguration
    ) {
        self.node = node
        self.network = .init(configuration: networkConfig)
    }
    
    // MARK: - Implementation
    
    /// Fetch full information about wallet address
    /// - Parameter address: UserFriendly TON address wallet
    /// - Returns: Model full information
    func getInfo(address: String) -> AnyPublisher<TONModels.Info, Error> {
        requestPublisher(for: .init(node: node, targetType: .getInfo(address: address)))
    }
    
    /// Fetch balance wallet by address
    /// - Parameter address: UserFriendly TON address wallet
    /// - Returns: String balance wallet adress or Error
    func getBalanceWallet(address: String) -> AnyPublisher<String, Error> {
        requestPublisher(for: .init(node: node, targetType: .getBalance(address: address)))
        
    }
    
    /// Get estimate sending transaction Fee
    /// - Parameter address: Wallet address
    /// - Parameter body: Body of message cell TON blockchain
    /// - Returns: Fees or Error
    func getFee(address: String, body: String?) -> AnyPublisher<TONModels.Fee, Error> {
        requestPublisher(for: .init(node: node, targetType: .estimateFee(address: address, body: body)))
    }
    
    /// Send transaction data message for raw cell TON
    /// - Parameter message: String data if cell message
    /// - Returns: Result of hash transaction
    func send(message: String) -> AnyPublisher<TONModels.SendBoc, Error> {
        requestPublisher(
            for: .init(node: node, targetType: .sendBocReturnHash(message: message))
        )
    }
    
    // MARK: - Private Implementation
    
    func getWalletAddress(address: String, contractAddress: String) -> AnyPublisher<TONModels.ResultStack, Error> {
        guard let convertedAddress = try? address.bocEncoded() else {
            return .emptyFail
        }
        let stack = [["tvm.Slice", convertedAddress]]
        
        return requestPublisher(
            for: TONProviderTarget(
                node: node,
                targetType: .runGetMethod(
                    parameters: TONModels.RunGetMethodParameters(
                        address: contractAddress,
                        method: "get_wallet_address",
                        stack: stack
                    )
                )
            )
        )
    }
    
    func getWalledData(walletAddress: String) -> AnyPublisher<TONModels.ResultStack, Error> {
        requestPublisher(
            for: TONProviderTarget(
                node: node,
                targetType: .runGetMethod(
                    parameters: TONModels.RunGetMethodParameters(
                        address: walletAddress,
                        method: "get_wallet_data",
                        stack: []
                    )
                )
            )
        )
    }
    
    private func requestPublisher<T: Codable>(for target: TONProviderTarget) -> AnyPublisher<T, Error> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return network.requestPublisher(target)
            .filterSuccessfulStatusAndRedirectCodes()
            .map(TONProviderResponse<T>.self, using: decoder)
            .map(\.result)
            .mapError { _ in WalletError.empty }
            .eraseToAnyPublisher()
    }
    
}

extension String {
    func bocEncoded() throws -> String {
        let addr = try TonAddress.parse(self)
        let builder = Builder()
        try addr.storeTo(builder: builder)
        return try builder.endCell().toBoc().base64EncodedString()
    }
}
