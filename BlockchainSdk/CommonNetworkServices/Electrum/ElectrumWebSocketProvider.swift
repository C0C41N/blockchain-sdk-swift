//
//  ElectrumWebSocketProvider.swift
//  BlockchainSdk
//
//  Created by Sergey Balashov on 11.03.2024.
//

import Foundation

class ElectrumWebSocketProvider: HostProvider {
    var host: String { webSocketProvider.host }
    
    private let webSocketProvider: JSONRPCWebSocketProvider
    private let encoder: JSONEncoder = .init()
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    public init(url: URL) {
        let ping: WebSocketConnection.Ping = {
            do {
                let request = JSONRPCWebSocketProvider.JSONRPCRequest(id: -1, method: Method.Server.ping.rawValue, params: [String]())
                let message = try request.string(encoder: .init())
                return .message(interval: Constants.pingInterval, message: .string(message))
            } catch {
                return .plain(interval: Constants.pingInterval)
            }
        }()
        
        webSocketProvider = JSONRPCWebSocketProvider(url: url, ping: ping, timeoutInterval: Constants.timeoutInterval)
    }
    
    func getBalance(identifier: Identifier) async throws -> ElectrumDTO.Response.Balance {
        switch identifier {
        case .address(let address):
            return try await send(method: Method.Blockchain.Address.getBalance, parameter: [address])
        case .scriptHash(let scriptHash):
            return try await send(method: Method.Blockchain.ScriptHash.getBalance, parameter: [scriptHash])
        }
    }
    
    func getTxHistory(identifier: Identifier) async throws -> [ElectrumDTO.Response.History] {
        switch identifier {
        case .address(let address):
            return try await send(method:  Method.Blockchain.Address.getHistory, parameter: [address])
        case .scriptHash(let scriptHash):
            return try await send(method: Method.Blockchain.ScriptHash.getHistory, parameter: [scriptHash])
        }
    }
    
    func getUnspents(identifier: Identifier) async throws -> [ElectrumDTO.Response.ListUnspent] {
        switch identifier {
        case .address(let address):
            return try await send(method: Method.Blockchain.Address.listunspent, parameter: [address])
        case .scriptHash(let scriptHash):
            return try await send(method: Method.Blockchain.ScriptHash.listunspent, parameter: [scriptHash])
        }
    }
    
    func send(transactionHex: String) async throws -> ElectrumDTO.Response.Broadcast {
        try await send(method: Method.Blockchain.Transaction.broadcast, parameter: transactionHex)
    }
    
    func estimateFee(block: Int) async throws -> Int {
        try await send(method: Method.Blockchain.estimatefee, parameter: [block])
    }
}

// MARK: - Private

private extension ElectrumWebSocketProvider {
    func send<Method, Parameter, Result>(method: Method, parameter: Parameter) async throws -> Result
    where Parameter: Encodable,
          Result: Decodable,
          Method: RawRepresentable,
          Method.RawValue == String {
        try await webSocketProvider.send(
            method: method.rawValue,
            parameter: parameter,
            encoder: encoder,
            decoder: decoder
        )
    }
}

// MARK: - Identifier

extension ElectrumWebSocketProvider {
    private enum Constants {
        static let pingInterval: TimeInterval = 5
        static let timeoutInterval: TimeInterval = 30
    }
    
    enum Identifier {
        case address(_ address: String)
        case scriptHash(_ hash: String)
    }
}

// MARK: - Methods

private extension ElectrumWebSocketProvider {
    enum Method {
        enum Server: String {
            case ping = "server.ping"
        }
        
        enum Blockchain: String {
            case estimatefee = "blockchain.estimatefee"
        }
    }
}

private extension ElectrumWebSocketProvider.Method.Blockchain {
    enum Transaction: String {
        case broadcast = "blockchain.transaction.broadcast"
    }
}

private extension ElectrumWebSocketProvider.Method.Blockchain {
    enum Address: String {
        case getBalance = "blockchain.address.get_balance"
        case getHistory = "blockchain.address.get_history"
        case listunspent = "blockchain.address.listunspent"
    }
    
    enum ScriptHash: String {
        case getBalance = "blockchain.scripthash.get_balance"
        case getHistory = "blockchain.scripthash.get_history"
        case listunspent = "blockchain.scripthash.listunspent"
    }
}
