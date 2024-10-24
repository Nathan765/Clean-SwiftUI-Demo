//
//  DataBaseError.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 21/10/2024.
//

import Foundation

enum DataBaseError: Error, LocalizedError {
    
    enum RealmServiceError: Error {
        case initializationError
        case writeError
        case readError
        case deleteError
        case mappingError
    }
    
    case itemNotFound
    case realmNotInitialized
    case saveFailed
    case deleteFailed
    case fetchFailed
    case invalidType
    case modelContainerInitializationFailed
    case decode(String)
    case error(String)
    case unknown(String)
    
    public var errorDescription: String? {
        switch self {
        case .decode(let error): "Decode error: \(error)"
        case .error(let error): "Error: \(error)"
        case .unknown(let error): "Unknown error: \(error)"
        default: "\(self)"
        }
    }
}
