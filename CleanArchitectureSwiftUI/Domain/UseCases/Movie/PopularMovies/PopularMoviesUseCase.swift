//
//  PopularMoviesUseCase.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 21/10/2024.
//

protocol PopularMoviesUseCase {
    func execute(page: Int) async throws -> [Movie]
}
