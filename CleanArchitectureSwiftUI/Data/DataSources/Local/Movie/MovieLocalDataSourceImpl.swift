//
//  MovieLocalDataSourceImpl.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 21/10/2024.
//

class MovieLocalDataSourceImpl: MovieLocalDataSource {
    private let databaseService: DatabaseService
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func saveMovie(_ movie: MovieDataModel) async throws {
        do {
            try await databaseService.create(movie)
        } catch {
            throw error
        }
    }
    
    func saveMovies(_ movies: [MovieDataModel]) async throws {
        do {
            try await databaseService.create(movies)
        } catch {
            throw error
        }
    }
    
    func getMovies() async throws -> [MovieDataModel] {
        do {
            return try await databaseService.read()
        } catch {
            throw error
        }
    }
}

class ActorLocalDataSourceImpl: ActorLocalDataSource {    
    private let databaseService: DatabaseService
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func saveActor(_ actor: ActorDataModel) async throws {
        do {
            try await databaseService.create(actor)
        } catch {
            throw error
        }
    }
    
    func saveActors(_ actors: [ActorDataModel]) async throws {
        do {
            try await databaseService.create(actors)
        } catch {
            throw error
        }
    }
    
    func getActors() async throws -> [ActorDataModel] {
        do {
            return try await databaseService.read()
        } catch {
            throw error
        }
    }
}
