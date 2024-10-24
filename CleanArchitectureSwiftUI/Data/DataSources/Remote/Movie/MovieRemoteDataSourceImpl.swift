//
//  MovieRemoteDataSourceImpl.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

class MovieRemoteDataSourceImpl: MovieRemoteDataSource {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchMovieDetails(movieId: Int) async throws -> MovieDataModel {
        do {
            let apiResponse: MovieDetailsApiResponse = try await self.networkService.performRequest(on: TmdbProvider.movie(.details(movieId: movieId, language: "fr-FR")))
            guard let dataModel = apiResponse.toDataModel() else {
                throw NetworkError.unknown("")
            }
            return dataModel
            
        } catch {
            throw error
        }
    }
    
    func fetchUpcomingMovies(page: Int) async throws -> [MovieDataModel] {
        do {
            let apiResponse: UpcomingMoviesApiResponse = try await self.networkService.performRequest(on: TmdbProvider.movie(.upcoming(language: "fr-FR", page: page, region: "")))
            guard let dataModel = apiResponse.toDataModels() else {
                throw NetworkError.unknown("")
            }
            return dataModel
            
        } catch {
            throw error
        }
    }
    
    func fetchTopRatedMovies(page: Int) async throws -> [MovieDataModel] {
        do {
            let apiResponse: TopRatedMoviesApiResponse = try await self.networkService.performRequest(on: TmdbProvider.movie(.topRated(language: "fr-FR", page: page, region: "")))
            guard let dataModel = apiResponse.toDataModels() else {
                throw NetworkError.unknown("")
            }
            return dataModel
            
        } catch {
            throw error
        }
    }
    
    func fetchPopularMovies(page: Int) async throws -> [MovieDataModel] {
        do {
            let apiResponse: PopularMoviesApiResponse = try await self.networkService.performRequest(on: TmdbProvider.movie(.popular(language: "fr-FR", page: page, region: "")))
            guard let dataModel = apiResponse.toDataModels() else {
                throw NetworkError.clientError(client: "Moya", error: "popularMoviesDataModels is nil")
            }
            return dataModel
            
        } catch {
            throw error
        }
    }
}
