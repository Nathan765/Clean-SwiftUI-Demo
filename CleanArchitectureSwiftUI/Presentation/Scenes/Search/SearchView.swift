//
//  SearchView.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 19/10/2024.
//

import SwiftUI

struct SearchView<ViewModel: SearchViewModel>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    SearchBarView(text: $viewModel.searchText)
                    
                    TabFilterView(
                        tabs: viewModel.tabs,
                        selectedTab: $viewModel.selectedTab,
                        onTabChanged: {
                            viewModel.tabChanged()
                        }
                    )
                    
                    MovieListContentView(
                        movies: viewModel.movies,
                        onMovieAppear: { movie in
                            viewModel.loadMoreIfNeeded(currentItem: movie)
                        }
                    )
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.purple)
                }
            }
            .navigationTitle(viewModel.tabs[viewModel.selectedTab])
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.fetchMovies()
            }
        }
    }
}

struct SearchBarView: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search any movies or person", text: $text)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

struct TabFilterView: View {
    let tabs: [String]
    @Binding var selectedTab: Int
    let onTabChanged: () -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Button(action: {
                        selectedTab = index
                        onTabChanged()
                    }) {
                        Text(tabs[index])
                            .foregroundColor(selectedTab == index ? .yellow : .gray)
                            .padding(.horizontal, index == 0 ? 0 : 8)
                            .padding(.vertical, 8)
                            .background(
                                selectedTab == index ?
                                    Color.yellow.opacity(0.2) :
                                    Color.clear
                            )
                            .cornerRadius(16)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct MovieListContentView: View {
    let movies: [MovieDTO]
    let onMovieAppear: (MovieDTO) -> Void
    @State private var selectedImageURL: IdentifiableURL? = nil
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(movies) { movie in
                    MovieRowView(movie: movie) {
                        if let posterPath = movie.posterPath,
                           let url = URL(string: "https://image.tmdb.org/t/p/original\(posterPath)") {
                            selectedImageURL = IdentifiableURL(url: url)
                        }
                    }
                    .onAppear {
                        onMovieAppear(movie)
                    }
                }
            }
            .padding()
        }
        .fullScreenCover(item: $selectedImageURL) { identifiableURL in
            FullScreenImageView(imageURL: identifiableURL.url)
        }
    }
}

struct MovieRowView: View {
    let movie: MovieDTO
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Poster placeholder
            if let posterPath = movie.posterPath {
                let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")!
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 100, height: 150)
                .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 150)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(movie.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                
                Text(movie.releaseDate)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text(movie.overview)
                    .font(.system(size: 11))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .frame(height: 150)
        .onTapGesture(perform: onTap)
    }
}

#Preview {
    SearchView(viewModel: SearchSceneConfigurator.configureView())
}


struct SearchView2<ViewModel: SearchViewModel2>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    MovieListContentView2(
                        movies: viewModel.movies,
                        onMovieAppear: { movie in
                            viewModel.loadMoreIfNeeded(currentItem: movie)
                        }
                    )
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.yellow)
                }
            }
            .searchable(text: $viewModel.searchText)
            .searchScopes($viewModel.selectedScope) {
                ForEach(MovieScope.allCases, id: \.self) { scope in
                    Text(scope.rawValue)
                        .tag(scope)
                }
            }
            .onChange(of: viewModel.selectedScope) { _ in
                viewModel.scopeChanged()
            }
            .navigationTitle("Movies")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.fetchMovies()
            }
        }
    }
}

struct MovieListContentView2: View {
    let movies: [MovieDTO]
    let onMovieAppear: (MovieDTO) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(movies) { movie in
                    MovieRowView2(movie: movie)
                        .onAppear {
                            onMovieAppear(movie)
                        }
                }
            }
            .padding()
        }
    }
}

struct MovieRowView2: View {
    let movie: MovieDTO
    
    var body: some View {
        HStack(spacing: 16) {
            // Poster placeholder
            if let posterPath = movie.posterPath {
                let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")!
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 100, height: 150)
                .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 150)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                
                Spacer()
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .frame(height: 150)
    }
}
