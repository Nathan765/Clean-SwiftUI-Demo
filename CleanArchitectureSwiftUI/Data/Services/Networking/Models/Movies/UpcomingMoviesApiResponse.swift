//
//  UpcomingMoviesApiResponse.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

struct UpcomingMoviesApiResponse: Decodable {
    let page: Int?
    let movies: MovieDetailsApiResponses?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
