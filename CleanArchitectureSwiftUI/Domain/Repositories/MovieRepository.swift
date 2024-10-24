//
//  MovieRepository.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

protocol MovieRepository {
    /// Récupère les détails d'un film spécifique
    /// - Parameter movieId: L'identifiant du film
    /// - Returns: Les détails du film
    /// - Throws: Une erreur si la récupération échoue
    func fetchMovieDetails(movieId: Int) async throws -> Movie
    
    /// Récupère les films à venir
    /// - Parameter page: Le numéro de page pour la pagination
    /// - Returns: Une liste de films à venir
    /// - Throws: Une erreur si la récupération échoue
    func fetchUpcomingMovies(page: Int) async throws -> [Movie]
    
    /// Récupère les films les mieux notés
    /// - Parameter page: Le numéro de page pour la pagination
    /// - Returns: Une liste de films à venir
    /// - Throws: Une erreur si la récupération échoue
    func fetchTopRatedMovies(page: Int) async throws -> [Movie]
    
    /// Récupère les films les plus populaire
    /// - Parameter page: Le numéro de page pour la pagination
    /// - Returns: Une liste de films à venir
    /// - Throws: Une erreur si la récupération échoue
    func fetchPopularMovies(page: Int) async throws -> [Movie]
}
