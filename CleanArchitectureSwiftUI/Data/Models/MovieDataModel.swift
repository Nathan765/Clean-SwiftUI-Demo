//
//  MovieAPIDataModel.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

import Foundation

struct MovieDataModel: DatabaseMappable {
    let id: Int
    let title: String
    let popularity: Double
    let posterPath: String
    let overview: String
    let releaseDate: String
    
    func toRealmModel() -> MovieRealmModel {
        let movie = MovieRealmModel()
        movie.id = id
        movie.title = title
        movie.popularity = popularity
        movie.posterPath = posterPath
        movie.overview = overview
        movie.releaseDate = releaseDate
        return movie
    }
    
    func toSQLModel() -> MovieSQLModel {
        MovieSQLModel(id: id, title: title)
    }
}

//extension MovieDataModel: DataModelConvertible {
//    typealias RealmType = MovieRealmModel
//
//    func toRealmModel() -> MovieRealmModel {
//        let realmMovie = MovieRealmModel()
//        realmMovie.id = id
//        realmMovie.title = title
//        realmMovie.popularity = popularity
//        realmMovie.posterPath = posterPath
//        return realmMovie
//    }
//}

// MARK: - Domain
extension MovieDataModel {
    func toDomain() -> Movie {
        Movie(
            id: id,
            title: title,
            popularity: popularity,
            posterPath: posterPath,
            overview: overview,
            releaseDate: releaseDate
        )
    }
}

// MARK: - SwiftData
extension MovieDataModel {
    func toSwiftData() -> MovieSwiftData {
        MovieSwiftData(
            id: id,
            title: title
        )
    }
}

struct MovieSQLModel: DatabaseModel {
    let id: Int
    let title: String
}

struct ActorSQLModel: DatabaseModel {
    let id: Int
    let name: String
    let profilePath: String
}
