//
//  TopRatedMoviesUseCaseImpl.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 21/10/2024.
//

class TopRatedMoviesUseCaseImpl: TopRatedMoviesUseCase {
    private let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(page: Int) async throws -> [Movie] {
        try await self.movieRepository.fetchTopRatedMovies(page: page)
    }
}
