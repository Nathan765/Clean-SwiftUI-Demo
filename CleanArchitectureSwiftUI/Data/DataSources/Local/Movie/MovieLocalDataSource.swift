//
//  MovieLocalDataSource.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 21/10/2024.
//

protocol MovieLocalDataSource {
    func saveMovie(_ movie: MovieDataModel) async throws
    func saveMovies(_ movies: [MovieDataModel]) async throws
    func getMovies() async throws -> [MovieDataModel]
}

protocol ActorLocalDataSource {
    func saveActor(_ actor: ActorDataModel) async throws
    func saveActors(_ actor: [ActorDataModel]) async throws
    func getActors() async throws -> [ActorDataModel]
}
