//
//  MoyaNetworkServiceImpl.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

import Moya

class MoyaNetworkServiceImpl: NetworkService {
    private let provider: MoyaProvider<MultiTarget>
    
    init(provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>()) {
        self.provider = provider
    }
    
    func performRequest<D: Decodable>(on endpoint: NetworkTargetType) async throws -> D {
        try await withCheckedThrowingContinuation { continuation in
            
            self.provider.request(MultiTarget(endpoint.asTargetType())) { result in
                do {
                    let rawResponse = try result.get()
                    let filteredResponse = try rawResponse.filterSuccessfulStatusCodes()
                    let model = try filteredResponse.map(D.self)
                    
                    continuation.resume(returning: model)
                } catch let error {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
