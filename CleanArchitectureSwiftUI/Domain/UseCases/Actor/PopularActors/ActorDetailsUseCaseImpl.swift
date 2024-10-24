//
//  ActorDetailsUseCaseImpl.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 23/10/2024.
//

class ActorDetailsUseCaseImpl: ActorDetailsUseCase {
    private let repository: ActorRepository
    
    init(repository: ActorRepository) {
        self.repository = repository
    }
    
    func execute(personId: Int) async throws -> Actor {
        try await self.repository.fetchActorDetails(personId: personId)
    }
}
