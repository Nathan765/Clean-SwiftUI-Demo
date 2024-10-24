//
//  Actor.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 23/10/2024.
//

import Foundation

struct Actor {
    let id: Int
    let name: String
    let profilePath: String
    
    init(id: Int, name: String, profilePath: String) {
        self.id = id
        self.name = name
        self.profilePath = profilePath
    }
}

extension Actor {
    func toDTO() -> ActorDTO {
        ActorDTO(
            name: name,
            profilePath: profilePath
        )
    }
}

extension Movie {
    var isPopular: Bool {
        true
    }
}
