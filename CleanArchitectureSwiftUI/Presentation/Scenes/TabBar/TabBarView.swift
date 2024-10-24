//
//  TabBarView.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 19/10/2024.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            HomeSceneView(viewModel: HomeSceneConfigurator.configureView())
                .tabItem {
                    Label("Accueil", systemImage: "film.stack")
                }
            
            SearchView(viewModel: SearchSceneConfigurator.configureView())
                .tabItem {
                    Label("Recherche", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    TabBarView()
}
