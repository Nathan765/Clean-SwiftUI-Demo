//
//  MovieDetailsUseCaseImpl.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

class MovieDetailsUseCaseImpl: MovieDetailsUseCase {
    private let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(movieId: Int) async throws -> Movie {
        try await self.movieRepository.fetchMovieDetails(movieId: movieId)
    }
}
