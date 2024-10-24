//
//  MovieRepositoryImpl.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

class MovieRepositoryImpl: MovieRepository {
    let localDataSource: any MovieLocalDataSource
    let remoteDataSource: any MovieRemoteDataSource
    
    init(localDataSource: MovieLocalDataSource, remoteDataSource: MovieRemoteDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
}

extension MovieRepositoryImpl {
    func fetchMovieDetails(movieId: Int) async throws -> Movie {
        do {
            return try await self.remoteDataSource.fetchMovieDetails(movieId: movieId).toDomain()
        } catch {
            throw error
        }
    }
    
    func fetchUpcomingMovies(page: Int) async throws -> [Movie] {
        do {
            var remoteMovies = try await self.remoteDataSource.fetchUpcomingMovies(page: page)
            
            guard !remoteMovies.isEmpty else {
                throw NetworkError.clientError(client: "Moya", error: "upcomingMovieDataModels is empty")
            }
            
            try await self.localDataSource.saveMovies(remoteMovies)
            
            let localMovies = try await self.localDataSource.getMovies() //.prefix(20)
            remoteMovies.append(contentsOf: localMovies)
//            print(localMovies.count)
            
            return remoteMovies.map { $0.toDomain() }
            
        } catch {
            throw error
        }
    }
    
    func fetchTopRatedMovies(page: Int) async throws -> [Movie] {
        do {
            let topRatedMoviesDataModels = try await self.remoteDataSource.fetchTopRatedMovies(page: page)
            guard !topRatedMoviesDataModels.isEmpty else {
                throw NetworkError.clientError(client: "Moya", error: "topRatedMoviesDataModels is empty")
            }
            return topRatedMoviesDataModels.map { $0.toDomain() }
            
        } catch {
            throw error
        }
    }
    
    func fetchPopularMovies(page: Int) async throws -> [Movie] {
        do {
            let popularMoviesDataModels = try await self.remoteDataSource.fetchPopularMovies(page: page)
            guard !popularMoviesDataModels.isEmpty else {
                throw NetworkError.clientError(client: "Moya", error: "popularMoviesDataModels is empty")
            }
            return popularMoviesDataModels.map { $0.toDomain() }
            
        } catch {
            throw error
        }
    }
}
