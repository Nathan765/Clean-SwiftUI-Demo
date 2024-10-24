//
//  UpcomingMoviesUseCase.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

protocol UpcomingMoviesUseCase {
    func execute(page: Int) async throws -> [Movie]
}
