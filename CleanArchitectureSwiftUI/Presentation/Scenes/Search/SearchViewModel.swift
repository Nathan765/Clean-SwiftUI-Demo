//
//  SearchViewModel.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 24/10/2024.
//

import Foundation
import Combine

protocol SearchViewModel: ObservableObject {
    var searchText: String { get set }
    var selectedTab: Int { get set }
    var movies: [MovieDTO] { get set }
    var isLoading: Bool { get set }
    var tabs: [String] { get }
    
    func fetchMovies() async
    func loadMoreIfNeeded(currentItem movie: MovieDTO)
    func tabChanged()
}

class SearchViewModelImpl: SearchViewModel {
    private let upcomingMoviesUseCase: any UpcomingMoviesUseCase
    private let topRatedMoviesUseCase: any TopRatedMoviesUseCase
    private let popularMoviesUseCase: any PopularMoviesUseCase
    
    @Published var searchText = ""
    @Published var selectedTab = 0
    @Published var movies: [MovieDTO] = []
    @Published var isLoading = false
    
    let tabs = ["Populaires", "Mieux Notés", "À venir", "Favoris"]
    
    private var currentPage = 1
    
    init(
        upcomingMoviesUseCase: UpcomingMoviesUseCase,
        topRatedMoviesUseCase: TopRatedMoviesUseCase,
        popularMoviesUseCase: PopularMoviesUseCase
    ) {
        self.upcomingMoviesUseCase = upcomingMoviesUseCase
        self.topRatedMoviesUseCase = topRatedMoviesUseCase
        self.popularMoviesUseCase = popularMoviesUseCase
    }
    
    @MainActor
    func fetchMovies() async {
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let newMovies: [MovieDTO]
            
            switch selectedTab {
            case 0:
                newMovies = try await popularMoviesUseCase.execute(page: currentPage).map { $0.toDTO() }
            case 1:
                newMovies = try await topRatedMoviesUseCase.execute(page: currentPage).map { $0.toDTO() }
            case 2:
                newMovies = try await upcomingMoviesUseCase.execute(page: currentPage).map { $0.toDTO() }
            default:
                return
            }
            
            if currentPage == 1 {
                movies = newMovies
            } else {
                movies.append(contentsOf: newMovies)
            }
            currentPage += 1
        } catch {
            print("Error fetching movies: \(error)")
        }
    }
    
    func loadMoreIfNeeded(currentItem movie: MovieDTO) {
        let thresholdIndex = movies.index(movies.endIndex, offsetBy: -5)
        if movies.firstIndex(where: { $0.id == movie.id }) == thresholdIndex {
            Task {
                await fetchMovies()
            }
        }
    }
    
    func tabChanged() {
        currentPage = 1
        Task {
            await fetchMovies()
        }
    }
}


// MARK: - Search Scope Enum
enum MovieScope: String, CaseIterable {
    case popular = "Popular"
    case topRated = "Top Rated"
    case upcoming = "Upcoming"
    case nowPlaying = "Now Play"
    
    var index: Int {
        switch self {
        case .popular: return 0
        case .topRated: return 1
        case .upcoming: return 2
        case .nowPlaying: return 3
        }
    }
}

protocol SearchViewModel2: ObservableObject {
    var searchText: String { get set }
    var selectedScope: MovieScope { get set }
    
    var movies: [MovieDTO] { get set }
    var isLoading: Bool { get set }
    var tabs: [String] { get }
    
    func fetchMovies() async
    func loadMoreIfNeeded(currentItem movie: MovieDTO)
    func scopeChanged()
}

class SearchViewModelImpl2: SearchViewModel2 {
    private let upcomingMoviesUseCase: any UpcomingMoviesUseCase
    private let topRatedMoviesUseCase: any TopRatedMoviesUseCase
    private let popularMoviesUseCase: any PopularMoviesUseCase
    
    @Published var searchText = ""
    @Published var selectedScope: MovieScope = .popular
    @Published var movies: [MovieDTO] = []
    @Published var isLoading = false
    
    let tabs = ["Populaires", "Mieux Notés", "À venir", "Favoris"]
    
    private var currentPage = 1
    
    init(
        upcomingMoviesUseCase: UpcomingMoviesUseCase,
        topRatedMoviesUseCase: TopRatedMoviesUseCase,
        popularMoviesUseCase: PopularMoviesUseCase
    ) {
        self.upcomingMoviesUseCase = upcomingMoviesUseCase
        self.topRatedMoviesUseCase = topRatedMoviesUseCase
        self.popularMoviesUseCase = popularMoviesUseCase
    }
        
    @MainActor
    func fetchMovies() async {
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let newMovies: [MovieDTO]
            
            switch selectedScope {
            case .popular:
                newMovies = try await popularMoviesUseCase.execute(page: currentPage).map { $0.toDTO() }
            case .topRated:
                newMovies = try await topRatedMoviesUseCase.execute(page: currentPage).map { $0.toDTO() }
            case .upcoming:
                newMovies = try await upcomingMoviesUseCase.execute(page: currentPage).map { $0.toDTO() }
            case .nowPlaying:
                return // Implement if needed
            }
            
            if currentPage == 1 {
                movies = newMovies
            } else {
                movies.append(contentsOf: newMovies)
            }
            currentPage += 1
        } catch {
            print("Error fetching movies: \(error)")
        }
    }
    
    func loadMoreIfNeeded(currentItem movie: MovieDTO) {
        let thresholdIndex = movies.index(movies.endIndex, offsetBy: -5)
        if movies.firstIndex(where: { $0.id == movie.id }) == thresholdIndex {
            Task {
                await fetchMovies()
            }
        }
    }
        
    func scopeChanged() {
        currentPage = 1
        Task {
            await fetchMovies()
        }
    }
}
