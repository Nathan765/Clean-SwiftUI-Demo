//
//  NetworkTargetType+Moya.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 22/10/2024.
//

import Moya

// MARK: - Moya Implementation
extension NetworkTargetType {
    func asTargetType() -> TargetType {
        MoyaEndpointAdapter(endpoint: self)
    }
}

fileprivate struct MoyaEndpointAdapter: TargetType {
    let endpoint: NetworkTargetType
    
    var baseURL: URL { endpoint.baseURL }
    var path: String { endpoint.path }
    var method: Moya.Method { Moya.Method(rawValue: endpoint.method.rawValue) }
    var task: Task {
        if let parameters = endpoint.parameters {
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
        return .requestPlain
    }
    var headers: [String: String]? { endpoint.headers }
    var sampleData: Data { Data() }
}
