//
//  UpcomingMoviesApiResponse+Mapper.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

extension UpcomingMoviesApiResponse {
    func toDataModels() -> [MovieDataModel]? {
        movies?.map {
            MovieDataModel(
                id: $0.id ?? 666,
                title: $0.title ?? "title",
                popularity: $0.popularity ?? .zero,
                posterPath: $0.posterPath ?? "posterPath",
                overview: $0.overview ?? "overview",
                releaseDate: $0.releaseDate ?? "releaseDate"
            )
        }
    }
}
