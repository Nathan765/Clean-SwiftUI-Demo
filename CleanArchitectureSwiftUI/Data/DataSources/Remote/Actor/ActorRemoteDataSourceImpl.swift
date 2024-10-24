//
//  ActorRemoteDataSourceImpl.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 23/10/2024.
//

class ActorRemoteDataSourceImpl: ActorRemoteDataSource {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchActorDetails(personId: Int) async throws -> ActorDataModel {
        do {
            let apiResponse: ActorDetailsApiResponse = try await self.networkService.performRequest(on: TmdbProvider.person(.details(personId: personId, language: "fr-FR")))
            guard let dataModel = apiResponse.toDataModel() else {
                throw NetworkError.unknown("")
            }
            return dataModel
            
        } catch {
            throw error
        }
    }
    
    func fetchPopularActors(page: Int) async throws -> [ActorDataModel] {
        do {
            let apiResponse: PopularActorsApiResponse = try await self.networkService.performRequest(on: TmdbProvider.person(.popular(language: "fr-FR", page: page)))
            guard let dataModel = apiResponse.toDataModels() else {
                throw NetworkError.unknown("")
            }
            return dataModel
            
        } catch {
            throw error
        }
    }
}
