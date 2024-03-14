//
//  WebSocketConnection.swift
//  BlockchainSdk
//
//  Created by Sergey Balashov on 11.03.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation

actor WebSocketConnection {
    private let url: URL
    private let ping: Ping
    private let timeout: TimeInterval
    
    private var _sessionWebSocketTask: Task<URLSessionWebSocketTaskWrapper, Never>?
    private var pingTask: Task<Void, Error>?
    private var timeoutTask: Task<Void, Error>?

    /// - Parameters:
    ///   - url: A `wss` URL
    ///   - ping: The value that will be sent after a certain interval in seconds
    ///   - timeout: The value in seconds through which the connection will be terminated, if there are no new `send` calls
    init(url: URL, ping: Ping, timeout: TimeInterval) {
        self.url = url
        self.ping = ping
        self.timeout = timeout
        
        log("init")
    }
    
    deinit {
//        Task { 
//            await disconnect()
            log("deinit")
//        }
    }
    
    public func send(_ message: URLSessionWebSocketTask.Message) async throws {
        let webSocketTask = await setupWebSocketTask()
        log("Send: \(message)")

        // Send a message
        try await webSocketTask.send(message: message)
//        startPingTask()

        // Restart the disconnect timer
        startTimeoutTask()
    }

    public func receive() async throws -> Data {
        guard let webSocket = await _sessionWebSocketTask?.value else {
            throw WebSocketConnectionError.webSocketNotFound
        }
        
        // Get a message from the last response
        let response = try await webSocket.receive()
        log("Receive: \(response)")
        
        let data = try mapToData(from: response)
        return data
    }
    
    public func disconnect() async {
        pingTask?.cancel()
        timeoutTask?.cancel()

        let closeCode = await _sessionWebSocketTask?.value.disconnect()
        self.log("Connection did close with: \(String(describing: closeCode))")

        _sessionWebSocketTask = nil
    }
}

// MARK: - Private

private extension WebSocketConnection {
    func startPingTask() {
        pingTask?.cancel()
        pingTask = Task { [weak self] in
            guard let self else { return }

            try await Task.sleep(nanoseconds: UInt64(ping.interval) * NSEC_PER_SEC)
            
            try Task.checkCancellation()
            
            try await ping()
        }
    }
    
    func startTimeoutTask() {
        timeoutTask?.cancel()
        timeoutTask = Task { [weak self] in
            guard let self else { return }

            try await Task.sleep(nanoseconds: UInt64(timeout) * NSEC_PER_SEC)
            
            try Task.checkCancellation()
            
            await disconnect()
        }
    }
    
    func ping() async throws {
        guard let webSocket = await _sessionWebSocketTask?.value else {
            throw WebSocketConnectionError.webSocketNotFound
        }
        
        switch ping {
        case .message(_, let message):
            log("Send ping: \(message)")
            try await webSocket.send(message: message)

        case .plain:
            log("Send plain ping")
            try await webSocket.sendPing()
        }
        
        startPingTask()
    }
    
    func setupWebSocketTask() async -> URLSessionWebSocketTaskWrapper {
        if let _sessionWebSocketTask {
            let socket = await _sessionWebSocketTask.value
            log("Return existed URLSessionWebSocketTaskWrapper \(socket)")
            return socket
        }

        let connectingTask = Task {
            let socket = URLSessionWebSocketTaskWrapper(url: url)
            
            log("\(socket) start connect")
            await socket.connect()
            log("\(socket) did open")

            return socket
        }
        
        _sessionWebSocketTask = connectingTask
        return await connectingTask.value
    }
    
    func mapToData(from message: URLSessionWebSocketTask.Message) throws -> Data {
        switch message {
        case .data(let data):
            return data
            
        case .string(let string):
            guard let data = string.data(using: .utf8) else {
                throw WebSocketConnectionError.invalidResponse
            }

            return data
            
        @unknown default:
            fatalError()
        }
    }
    
    nonisolated func log(_ args: Any) {
        print("\(self) [\(args)]")
   }
}

extension WebSocketConnection: CustomStringConvertible {
    nonisolated var description: String {
        objectDescription(self)
    }
}

// MARK: - Model

extension WebSocketConnection {
    enum Ping {
        case plain(interval: TimeInterval)
        case message(interval: TimeInterval, message: URLSessionWebSocketTask.Message)
        
        var interval: TimeInterval {
            switch self {
            case .plain(let interval):
                return interval
            case .message(let interval, _):
                return interval
            }
        }
    }
}

// MARK: - Error

enum WebSocketConnectionError: Error {
    case webSocketNotFound
//    case responseNotFound
    case invalidResponse
//    case invalidRequest
}

// MARK: - URLSessionTask.State + CustomStringConvertible

extension URLSessionTask.State: CustomStringConvertible {
    public var description: String {
        switch self {
        case .running:
            return "URLSessionTask.State.running"
        case .suspended:
            return "URLSessionTask.State.suspended"
        case .canceling:
            return "URLSessionTask.State.canceling"
        case .completed:
            return "URLSessionTask.State.completed"
        @unknown default:
            return "URLSessionTask.State.@unknowndefault"
        }
    }
}

extension URLSessionWebSocketTask.Message: CustomStringConvertible {
    public var description: String {
        switch self {
        case .data(let data):
            return "URLSessionWebSocketTask.Message.data: \(data)"
        case .string(let string):
            return "URLSessionWebSocketTask.Message.string: \(string)"
        @unknown default:
            return "URLSessionWebSocketTask.Message.@unknowndefault"
        }
    }
}

extension URLSessionWebSocketTask.CloseCode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalid:
            return "URLSessionWebSocketTask.CloseCode.invalid"
        case .normalClosure:
            return "URLSessionWebSocketTask.CloseCode.normalClosure"
        case .goingAway:
            return "URLSessionWebSocketTask.CloseCode.goingAway"
        case .protocolError:
            return "URLSessionWebSocketTask.CloseCode.protocolError"
        case .unsupportedData:
            return "URLSessionWebSocketTask.CloseCode.unsupportedData"
        case .noStatusReceived:
            return "URLSessionWebSocketTask.CloseCode.noStatusReceived"
        case .abnormalClosure:
            return "URLSessionWebSocketTask.CloseCode.abnormalClosure"
        case .invalidFramePayloadData:
            return "URLSessionWebSocketTask.CloseCode.invalidFramePayloadData"
        case .policyViolation:
            return "URLSessionWebSocketTask.CloseCode.policyViolation"
        case .messageTooBig:
            return "URLSessionWebSocketTask.CloseCode.messageTooBig"
        case .mandatoryExtensionMissing:
            return "URLSessionWebSocketTask.CloseCode.mandatoryExtensionMissing"
        case .internalServerError:
            return "URLSessionWebSocketTask.CloseCode.internalServerError"
        case .tlsHandshakeFailure:
            return "URLSessionWebSocketTask.CloseCode.tlsHandshakeFailure"
        @unknown default:
            return "URLSessionWebSocketTask.CloseCode.@unknowndefault"
        }
    }
}
