//
//  PopularActorsApiResponse.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 23/10/2024.
//

struct PopularActorsApiResponse: Decodable {
    let page: Int?
    let actors: ActorDetailsApiResponses?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case actors = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
