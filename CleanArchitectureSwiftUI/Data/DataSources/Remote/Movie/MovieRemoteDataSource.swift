//
//  MovieRemoteDataSource.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

protocol MovieRemoteDataSource {
    // MARK: - MOVIE
    func fetchMovieDetails(movieId: Int) async throws -> MovieDataModel
    
    // MARK: - MOVIE LISTS
    func fetchUpcomingMovies(page: Int) async throws -> [MovieDataModel]
    func fetchTopRatedMovies(page: Int) async throws -> [MovieDataModel]
    func fetchPopularMovies(page: Int) async throws -> [MovieDataModel]
}
