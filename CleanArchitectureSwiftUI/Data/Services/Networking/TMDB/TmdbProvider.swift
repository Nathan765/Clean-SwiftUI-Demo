//
//  TmdbProvider.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 21/10/2024.
//

import Foundation

enum TmdbProvider {
    case account(Account)
    case movie(Movie)
    case person(Person)
}

extension TmdbProvider: NetworkTargetType {
    var baseURL: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case let .account(endpoint): endpoint.path
        case let .movie(endpoint): endpoint.path
        case let .person(endpoint): endpoint.path
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case let .account(endpoint): endpoint.method
        case let .movie(endpoint): endpoint.method
        case let .person(endpoint): endpoint.method
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .account(endpoint): endpoint.parameters
        case let .movie(endpoint): endpoint.parameters
        case let .person(endpoint): endpoint.parameters
        }
    }
    
    var headers: HTTPHeaders? {
        let optHeader: HTTPHeaders = switch self.method {
        case .get: ["Content-type": "application/json"]
        case .post: ["accept": "application/json"]
        default: HTTPHeaders()
        }
        
        return optHeader.merging(
            ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiZTU5MjA1OTUyYzA4ZGQzM2I5NmY5ZjVmZDkwMmFhNiIsInN1YiI6IjYwZjgwZjUyMzEwMzI1MDAyMzZkMTY2ZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.pbsH1uV4mpLaNz-sHw_CwNYUC6TNQrt65uLU9PbGtXY"]) { $1 }
    }
}

// MARK: - Account
extension TmdbProvider {
    enum Account {
        case details(accountId: Int, sessionId: String)
        case addFavorite(accountId: Int, sessionId: String, bodyParams: [String: Any])
        
        var pathSegment: String { "/account" }
        
        var path: String {
            switch self {
            case let .details(accountId, _): "\(pathSegment)/\(accountId)"
            case let .addFavorite(accountId, _, _): "\(pathSegment)/\(accountId)/favorite"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .details: .get
            case .addFavorite: .post
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case let .details(_, sessionId): ["session_id": sessionId]
            case let .addFavorite(_, sessionId, bodyParams): bodyParams.merging(["session_id": sessionId]) { (_, new) in new }
            }
        }
    }
}

// MARK: - Movie
extension TmdbProvider {
    enum Movie {
        case details(movieId: Int, language: String)
        case popular(language: String, page: Int, region: String)
        case topRated(language: String, page: Int, region: String)
        case upcoming(language: String, page: Int, region: String)
        
        var pathSegment: String { "/movie" }
        
        var path: String {
            switch self {
            case .details(let movieId, _): "\(pathSegment)/\(movieId)"
            case .popular: "\(pathSegment)/popular"
            case .upcoming: "\(pathSegment)/upcoming"
            case .topRated: "\(pathSegment)/top_rated"
            }
        }
        
        var method: HTTPMethod {
            .get
        }
        
        var parameters: [String: Any]? {
            switch self {
            case let .details(_, language): ["language": language]
            case let .upcoming(language, page, region),
                let .popular(language, page, region),
                let .topRated(language, page, region):
                ["language": language, "page": page, "region": region]
            }
        }
    }
}

// MARK: - Person
extension TmdbProvider {
    enum Person {
        case details(personId: Int, language: String)
        case popular(language: String, page: Int)
        
        var pathSegment: String { "/person" }
        
        var path: String {
            switch self {
            case .details(let personId, _): "\(pathSegment)/\(personId)"
            case .popular: "\(pathSegment)/popular"
            }
        }
        
        var method: HTTPMethod {
            .get
        }
        
        var parameters: [String: Any]? {
            switch self {
            case let .details(_, language): ["language": language]
            case let .popular(language, page): ["language": language, "page": page]
            }
        }
    }
}
