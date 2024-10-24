//
//  ActorRepositoryImpl.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 23/10/2024.
//

class ActorRepositoryImpl: ActorRepository {
    let localDataSource: any ActorLocalDataSource
    let remoteDataSource: any ActorRemoteDataSource
    
    init(localDataSource: ActorLocalDataSource, remoteDataSource: ActorRemoteDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource

    }
}

extension ActorRepositoryImpl {
    func fetchActorDetails(personId: Int) async throws -> Actor {
        do {
            var actorDetails = try await self.remoteDataSource.fetchActorDetails(personId: personId).toDomain()
            
            try await self.localDataSource.saveActor(ActorDataModel(id: 451666, name: "Evian", profilePath: ""))
//            actorDetails = try await self.localDataSource.getActors().first!.toDomain()
            return actorDetails
        } catch {
            throw error
        }
    }
    
    func fetchPopularActors(page: Int) async throws -> [Actor] {
        do {
            var actors = try await self.remoteDataSource.fetchPopularActors(page: page).map { $0.toDomain() }
            
            try await self.localDataSource.saveActor(ActorDataModel(id: 451666, name: "Evian", profilePath: ""))
            actors += try await self.localDataSource.getActors().map { $0.toDomain() }
            return actors
        } catch {
            throw error
        }
    }
}
