//
//  UpcomingMoviesUseCaseImpl.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

class UpcomingMoviesUseCaseImpl: UpcomingMoviesUseCase {
    private let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(page: Int) async throws -> [Movie] {
        try await self.movieRepository.fetchUpcomingMovies(page: page)// .filter { $0.isRecent } supprimer page
    }
}
