//
//  MovieDataClient.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 22/10/2024.
//

protocol MovieDataClient {
    // MARK: - CREATE
    func saveMovie(_ movie: MovieSwiftData) throws
    func saveMovies(_ movies: [MovieSwiftData]) throws
    
    // MARK: - READ
    func getMovie(byId id: Int) throws -> MovieSwiftData?
    func getMovies() throws -> [MovieSwiftData]
    
    // MARK: - UPDATE
    
    
    // MARK: - DELETE
    func deleteMovies() throws
}
