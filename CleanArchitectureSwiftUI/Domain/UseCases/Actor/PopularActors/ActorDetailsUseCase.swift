//
//  ActorDetailsUseCase.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 23/10/2024.
//

protocol ActorDetailsUseCase {
    func execute(personId: Int) async throws -> Actor
}
