//
//  MovieDetailsApiResponse+Mapper.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

import Foundation

extension MovieDetailsApiResponse {
    func toDataModel() -> MovieDataModel? {
        MovieDataModel(
            id: id ?? 666,
            title: title ?? "title",
            popularity: popularity ?? .zero,
            posterPath: posterPath ?? "posterPath",
            overview: overview ?? "overview",
            releaseDate: releaseDate ?? "releaseDate"
        )
    }
}
