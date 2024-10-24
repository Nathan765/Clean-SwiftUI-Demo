//
//  AlamofireNetworkServiceImpl.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 21/10/2024.
//

import Alamofire

class AlamofireNetworkServiceImpl: NetworkService {
    func performRequest<D: Decodable>(on endpoint: NetworkTargetType) async throws -> D {
        try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint.baseURL.appendingPathComponent(endpoint.path),
                       method: Alamofire.HTTPMethod(rawValue: endpoint.method.rawValue),
                       parameters: endpoint.parameters,
                       headers: Alamofire.HTTPHeaders(endpoint.headers ?? [:]))
            .responseDecodable(of: D.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
