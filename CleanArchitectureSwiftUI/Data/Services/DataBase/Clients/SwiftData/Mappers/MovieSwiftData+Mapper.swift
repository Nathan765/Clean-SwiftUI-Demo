//
//  MovieSwiftData+Mapper.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 22/10/2024.
//

extension MovieSwiftData {
    func toDataModel() -> MovieDataModel {
        MovieDataModel(
            id: id,
            title: title,
            popularity: .zero,
            posterPath: "posterPath",
            overview: "overview",
            releaseDate: "releaseDate"
        )
    }
}
