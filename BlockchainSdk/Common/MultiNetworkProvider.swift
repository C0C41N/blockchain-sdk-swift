//
//  MultiNetworkProvider.swift
//  BlockchainSdk
//
//  Created by Andrew Son on 12/03/21.
//  Copyright © 2021 Tangem AG. All rights reserved.
//

import Foundation
import Combine
import Moya

@available(iOS 13.0, *)
class MultiNetworkProvider<Provider> {
    
    internal let providers: [Provider]
    private var currentProviderIndex = 0
    
    var provider: Provider {
        providers[currentProviderIndex]
    }
    
    init(providers: [Provider]) {
        self.providers = providers
    }
    
    func providerPublisher<T>(for requestPublisher: @escaping (_ provider: Provider) -> AnyPublisher<T, Error>) -> AnyPublisher<T, Error> {
        requestPublisher(provider)
            .catch { [weak self] error -> AnyPublisher<T, Error> in
                if let moyaError = error as? MoyaError, case let .statusCode(resp) = moyaError {
                    print("Switchable publisher catched error: \(moyaError). Response message: \(String(data: resp.data, encoding: .utf8))")
                }
                print("Switchable publisher catched error:", error)
                if self?.needRetry() ?? false {
                    print("Switching to next publisher")
                    return self?.providerPublisher(for: requestPublisher) ?? .emptyFail
                }
                
                return .anyFail(error: error)
            }
            .eraseToAnyPublisher()
    }
    
    private func needRetry() -> Bool {
        currentProviderIndex += 1
        if currentProviderIndex < providers.count {
            return true
        }
        resetProviders()
        return false
    }
    
    private func resetProviders() {
        currentProviderIndex = 0
    }
}