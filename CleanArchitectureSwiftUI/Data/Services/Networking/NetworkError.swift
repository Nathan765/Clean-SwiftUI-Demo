//
//  NetworkError.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case statusCode(Int)
    case network(String)
    case decode(String)
    case error(String)
    case unknown(String)
    case download(String)
    case http(Int)
    case clientError(client: String, error: String)
    case data(String)
    
    public var errorDescription: String? {
        switch self {
        case .statusCode(let error): "Network error with statusCode: \(error)"
        case .network(let error): "Network error: \(error)"
        case .decode(let error): "Decode error: \(error)"
        case .error(let error): "Error: \(error)"
        case .unknown(let error): "Unknown error: \(error)"
        case .download(let error): "Download error: \(error)"
        case .http(let error): "Http error with statusCode: \(error)"
        case .clientError(let client, let error): "Client \(client) - error: \(error)"
        case .data(let error): "Data error: \(error)"
        }
    }
    
    static func from(code: Int) -> NetworkError {
        .http(code)
    }
}
