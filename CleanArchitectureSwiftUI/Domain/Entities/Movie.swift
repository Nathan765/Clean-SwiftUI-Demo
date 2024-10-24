//
//  Movie.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

import Foundation

struct Movie {
    let id: Int
    let title: String
    let popularity: Double
    let posterPath: String
    let overview: String
    let releaseDate: String
    
    init(id: Int, title: String, popularity: Double, posterPath: String, overview: String, releaseDate: String) {
        self.id = id
        self.title = title
        self.popularity = popularity
        self.posterPath = posterPath
        self.overview = overview
        self.releaseDate = releaseDate
    }
}

extension Movie {
    var isRecent: Bool {
        true // releaseDate > sixMonthsAgo = Date().addingTimeInterval(-180 * 24 * 3600)
    }
}

extension Movie {
    func toDTO() -> MovieDTO {
        MovieDTO(
            title: title,
            posterPath: posterPath,
            overview: overview,
            releaseDate: releaseDate
        )
    }
}
