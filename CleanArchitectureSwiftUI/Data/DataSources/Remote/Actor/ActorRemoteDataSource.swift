//
//  ActorRemoteDataSource.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 23/10/2024.
//

protocol ActorRemoteDataSource {
    func fetchActorDetails(personId: Int) async throws -> ActorDataModel
    func fetchPopularActors(page: Int) async throws -> [ActorDataModel]
}
