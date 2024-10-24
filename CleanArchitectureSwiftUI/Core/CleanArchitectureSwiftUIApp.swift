//
//  CleanArchitectureSwiftUIApp.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/02/2024.
//

import SwiftUI
import SwiftData

@main
struct CleanArchitectureSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
        .modelContainer(for: MovieSwiftData.self)
    }
}

#Preview {
    TabBarView()
}
