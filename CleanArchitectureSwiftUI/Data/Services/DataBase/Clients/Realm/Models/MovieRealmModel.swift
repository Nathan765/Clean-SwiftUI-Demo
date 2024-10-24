//
//  MovieRealmModel.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 22/10/2024.
//

import RealmSwift

final class MovieRealmModel: Object, RealmConvertible {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var popularity: Double
    @Persisted var posterPath: String
    @Persisted var overview: String
    @Persisted var releaseDate: String
    
    typealias DataModel = MovieDataModel
    
    func toDataModel() -> MovieDataModel {
        MovieDataModel(
            id: id,
            title: title,
            popularity: popularity,
            posterPath: posterPath,
            overview: overview,
            releaseDate: releaseDate
            
        )
    }
}


