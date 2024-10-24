//
//  TopRatedMoviesUseCase.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 21/10/2024.
//

protocol TopRatedMoviesUseCase {
    func execute(page: Int) async throws -> [Movie]
}
