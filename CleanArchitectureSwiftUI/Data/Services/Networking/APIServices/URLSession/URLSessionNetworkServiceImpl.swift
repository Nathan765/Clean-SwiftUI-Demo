//
//  URLSessionNetworkServiceImpl.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 21/10/2024.
//

import Foundation

class URLSessionNetworkServiceImpl: NetworkService {
    func performRequest<D: Decodable>(on endpoint: NetworkTargetType) async throws -> D {
        // Construire l'URL avec les paramètres d'endpoint
        var urlComponents = URLComponents(url: endpoint.baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false)
        if let parameters = endpoint.parameters {
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }

        guard let url = urlComponents?.url else {
            throw URLError(.badURL)
        }

        // Construire la requête
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        if let headers = endpoint.headers {
            headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        }

        // Exécuter la requête
        let (data, response) = try await URLSession.shared.data(for: request)

        // Vérifier la réponse HTTP
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        // Décoder la réponse JSON
        let decoder = JSONDecoder()
        do {
            let decodedResponse = try decoder.decode(D.self, from: data)
            return decodedResponse
        } catch {
            throw error
        }
    }
}
