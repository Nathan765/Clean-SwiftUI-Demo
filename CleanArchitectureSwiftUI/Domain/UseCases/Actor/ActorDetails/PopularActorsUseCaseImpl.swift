//
//  PopularActorsUseCaseImpl.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 23/10/2024.
//

class PopularActorsUseCaseImpl: PopularActorsUseCase {
    private let repository: ActorRepository
    
    init(repository: ActorRepository) {
        self.repository = repository
    }
    
    func execute(page: Int) async throws -> [Actor] {
        try await self.repository.fetchPopularActors(page: page)
    }
}
