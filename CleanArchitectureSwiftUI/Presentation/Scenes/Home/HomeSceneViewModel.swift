//
//  HomeSceneViewModel.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 20/10/2024.
//

import Foundation
import Combine

protocol HomeSceneViewModel: ObservableObject {
    var movieCategories: [(title: String, movies: MoviesDTO)] { get }
    var actorCategories: [(name: String, actors: ActorsDTO)] { get }
    
    func fetchAllData()
    func loadMoreIfNeeded(currentItem movie: MovieDTO, in categoryIndex: Int)
    func loadMoreIfNeeded(currentItem movie: ActorDTO, in categoryIndex: Int)
}

typealias MoviesDTO = [MovieDTO]

struct MovieDTO: Identifiable {
    let id = UUID()
    let title: String
    let posterPath: String?
    let overview: String
    let releaseDate: String
}

typealias ActorsDTO = [ActorDTO]

struct ActorDTO: Identifiable {
    let id = UUID()
    let name: String
    let profilePath: String?
}

//@MainActor
class HomeSceneViewModelImpl: HomeSceneViewModel {
    private let upcomingMoviesUseCase: any UpcomingMoviesUseCase
    private let topRatedMoviesUseCase: any TopRatedMoviesUseCase
    private let popularMoviesUseCase: any PopularMoviesUseCase
    private let popularActorsUseCase: any PopularActorsUseCase
    
    @Published var movieCategories: [(title: String, movies: MoviesDTO)] = [
          ("À venir", []),
          ("Mieux notés", []),
          ("Populaires", []),
      ]
    
    @Published var actorCategories: [(name: String, actors: ActorsDTO)] = [
          ("Acteur Populaires", []),
      ]
    
    private var currentPage = [1, 1, 1]
    private var isLoading = [false, false, false]
    
    init(upcomingMoviesUseCase: UpcomingMoviesUseCase, topRatedMoviesUseCase: TopRatedMoviesUseCase, popularMoviesUseCase: PopularMoviesUseCase, popularActorsUseCase: PopularActorsUseCase) {
        self.upcomingMoviesUseCase = upcomingMoviesUseCase
        self.topRatedMoviesUseCase = topRatedMoviesUseCase
        self.popularMoviesUseCase = popularMoviesUseCase
        self.popularActorsUseCase = popularActorsUseCase
    }
    
    func fetchAllData() {
        fetchAllMovies()
        fetchAllActors()
    }
    
    func fetchAllMovies() {
        Task {
            await fetchMovies(for: 0)
            await fetchMovies(for: 1)
            await fetchMovies(for: 2)
            await fetchActor(for: 0)
        }
    }
    
    func fetchAllActors() {
        Task {
            await fetchActor(for: 0)
        }
    }

    
    func loadMoreIfNeeded(currentItem movie: MovieDTO, in categoryIndex: Int) {
        let thresholdIndex = movieCategories[categoryIndex].movies.index(movieCategories[categoryIndex].movies.endIndex, offsetBy: -5)
        if movieCategories[categoryIndex].movies.firstIndex(where: { $0.id == movie.id }) == thresholdIndex {
            Task {
                await fetchMovies(for: categoryIndex)
            }
        }
    }
    
    func loadMoreIfNeeded(currentItem movie: ActorDTO, in categoryIndex: Int) {
        let thresholdIndex = actorCategories[categoryIndex].actors.index(actorCategories[categoryIndex].actors.endIndex, offsetBy: -5)
        if actorCategories[categoryIndex].actors.firstIndex(where: { $0.id == movie.id }) == thresholdIndex {
            Task {
                await fetchActor(for: categoryIndex)
            }
        }
    }
    
    private func fetchMovies(for categoryIndex: Int) async {
        guard !isLoading[categoryIndex] else { return }
        
        isLoading[categoryIndex] = true
        defer { isLoading[categoryIndex] = false }
        
        do {
            let newMovies: MoviesDTO
            switch categoryIndex {
            case 0:
                newMovies = try await upcomingMoviesUseCase.execute(page: currentPage[categoryIndex]).map { $0.toDTO() }
            case 1:
                newMovies = try await topRatedMoviesUseCase.execute(page: currentPage[categoryIndex]).map { $0.toDTO() }
            case 2:
                newMovies = try await popularMoviesUseCase.execute(page: currentPage[categoryIndex]).map { $0.toDTO() }
            default:
                return
            }
            
            await MainActor.run {
                movieCategories[categoryIndex].movies.append(contentsOf: newMovies)
                currentPage[categoryIndex] += 1
            }
        } catch {
            print("Erreur lors de la récupération des films pour la catégorie \(categoryIndex): \(error)")
        }
    }
    
    private func fetchActor(for categoryIndex: Int) async {
        guard !isLoading[categoryIndex] else { return }
        
        isLoading[categoryIndex] = true
        defer { isLoading[categoryIndex] = false }
        
        do {
            let newActors = try await popularActorsUseCase.execute(page: 1) .map { $0.toDTO() }
            
            await MainActor.run {
                actorCategories[categoryIndex].actors.append(contentsOf: newActors)
                currentPage[categoryIndex] += 1
            }
        } catch {
            print("Erreur lors de la récupération des films pour la catégorie \(categoryIndex): \(error)")
        }
    }
}
