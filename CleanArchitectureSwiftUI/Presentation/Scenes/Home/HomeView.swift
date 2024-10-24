//
//  HomeView.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 19/10/2024.
//

import SwiftUI

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}

struct HomeSceneView<ViewModel: HomeSceneViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    // État pour suivre le film sélectionné
    @State private var selectedMovie: MovieDTO? = nil
    @State private var selectedImageURL: IdentifiableURL? = nil
    @Namespace private var animation
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .darkText)
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(Array(viewModel.movieCategories.enumerated()), id: \.element.title) { index, category in
                        Text(category.title)
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(category.movies) { movie in
                                    MovieCardView(movie: movie) {
                                        if let posterPath = movie.posterPath,
                                           let url = URL(string: "https://image.tmdb.org/t/p/original\(posterPath)") {
                                            selectedImageURL = IdentifiableURL(url: url)
                                        }
                                    }
                                    .frame(width: 150, height: 225)
                                    .onAppear {
                                        viewModel.loadMoreIfNeeded(currentItem: movie, in: index)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    ForEach(Array(viewModel.actorCategories.enumerated()), id: \.element.name) { index, category in
                        Text(category.name)
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(category.actors) { actor in
                                    ActorCardView(actor: actor) {
                                        if let profilePath = actor.profilePath,
                                           let url = URL(string: "https://image.tmdb.org/t/p/original\(profilePath)") {
                                            selectedImageURL = IdentifiableURL(url: url)
                                        }
                                    }
                                    .frame(width: 150, height: 225)
                                    .onAppear {
                                        viewModel.loadMoreIfNeeded(currentItem: actor, in: index)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.top)
        }
        .onAppear {
            viewModel.fetchAllData()
        }
        .fullScreenCover(item: $selectedImageURL) { identifiableURL in
            FullScreenImageView(imageURL: identifiableURL.url)
        }
    }
}

#Preview {
    HomeSceneView(viewModel: HomeSceneConfigurator.configureView())
}

struct MovieCardView: View {
    let movie: MovieDTO
    let onTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Image du film
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath!)")!
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Color.gray // Image de remplacement en cas d'échec
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 150, height: 225)
            .clipped()
            .cornerRadius(10)
            
            // Titre du film
            Text(movie.title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.7))
                .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        }
        .frame(width: 150, height: 225)
        .shadow(radius: 5)
        .onTapGesture(perform: onTap)
    }
}

struct ActorCardView: View {
    let actor: ActorDTO
    let onTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Image du film
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/\(actor.profilePath!)")!
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Color.gray // Image de remplacement en cas d'échec
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 150, height: 225)
            .clipped()
            .cornerRadius(10)
            
            // Nom de l'acteur
            Text(actor.name)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.7))
                .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        }
        .frame(width: 150, height: 225)
        .shadow(radius: 5)
        .onTapGesture(perform: onTap)
    }
}

// Extension pour appliquer la cornerRadius seulement à certains coins
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct FullScreenImageView: View {
    let imageURL: URL
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .edgesIgnoringSafeArea(.all)
                case .failure:
                    Text("Impossible de charger l'image")
                        .foregroundColor(.white)
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }
}
