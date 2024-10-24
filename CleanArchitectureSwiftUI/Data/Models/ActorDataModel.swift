//
//  ActorDataModel.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 23/10/2024.
//
import Foundation

struct ActorDataModel: DatabaseMappable {
    let id: Int
    let name: String
    let profilePath: String
    
    func toRealmModel() -> ActorRealmModel {
        let actor = ActorRealmModel()
        actor.id = id
        actor.name = name
        actor.profilePath = profilePath
        return actor
    }
    
    func toSQLModel() -> ActorSQLModel {
        ActorSQLModel(id: id, name: name, profilePath: profilePath)
    }
}

// MARK: - Domain
extension ActorDataModel {
    func toDomain() -> Actor {
        Actor(
            id: id,
            name: name,
            profilePath: profilePath
        )
    }
}
