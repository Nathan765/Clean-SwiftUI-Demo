//
//  ActorRealmModel.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 23/10/2024.
//

import RealmSwift

final class ActorRealmModel: Object, RealmConvertible {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var profilePath: String
    
    typealias DataModel = ActorDataModel
    
    func toDataModel() -> ActorDataModel {
        ActorDataModel(
            id: id,
            name: name,
            profilePath: profilePath
        )
    }
}
