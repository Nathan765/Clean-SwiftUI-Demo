//
//  PopularActorsUseCase.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 23/10/2024.
//

protocol PopularActorsUseCase {
    func execute(page: Int) async throws -> [Actor]
}
