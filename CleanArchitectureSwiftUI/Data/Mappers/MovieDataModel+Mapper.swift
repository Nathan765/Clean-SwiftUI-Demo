//
//  MovieDataModel+Mapper.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//
//
//extension MovieDataModel {
//    func toDomain() -> Movie {
//        Movie(
//            id: id,
//            title: title,
//            popularity: popularity,
//            posterPath: posterPath
//        )
//    }
//}
//
//extension MovieDataModel {
//    func toSwiftData() -> MovieSwiftData {
//        MovieSwiftData(
//            id: id,
//            title: title
//        )
//    }
//}
//
//extension MovieDataModel {
//    func toRealmModel2() -> MovieRealmModel {
//        let realmMovie = MovieRealmModel()
//        realmMovie.id = id
//        realmMovie.title = title
//        realmMovie.popularity = popularity
//        realmMovie.posterPath = posterPath
//        
//        print("Converting to Realm - Title: \(self.title)") // Debug
//        return realmMovie
//    }
//}
