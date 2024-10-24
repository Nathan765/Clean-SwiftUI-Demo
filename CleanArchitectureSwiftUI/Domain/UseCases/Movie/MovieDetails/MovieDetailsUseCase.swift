//
//  MovieDetailsUseCase.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

protocol MovieDetailsUseCase {
    func execute(movieId: Int) async throws -> Movie
}
