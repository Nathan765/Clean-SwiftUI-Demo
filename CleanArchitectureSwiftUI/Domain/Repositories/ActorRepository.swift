//
//  ActorRepository.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 23/10/2024.
//

protocol ActorRepository {
    func fetchActorDetails(personId: Int) async throws -> Actor
    func fetchPopularActors(page: Int) async throws -> [Actor]
}
