//
//  NetworkService.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

protocol NetworkService {
    func performRequest<D: Decodable>(on endpoint: NetworkTargetType) async throws -> D
}
