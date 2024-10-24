//
//  DatabaseService.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 21/10/2024.
//

import RealmSwift

protocol DatabaseModel {}

// Protocol spécifique pour les modèles Realm
protocol RealmDatabaseModel: DatabaseModel, Object {}

// Extension pour faire le lien entre RealmDatabaseModel et Object
extension Object: RealmDatabaseModel {}

protocol RealmConvertible {
    associatedtype DataModel
    func toDataModel() -> DataModel
}

protocol DatabaseMappable {
//    associatedtype RealmType: RealmDatabaseModel
    associatedtype RealmType: Object & RealmConvertible where RealmType.DataModel == Self
    associatedtype SQLType: DatabaseModel
    
    func toRealmModel() -> RealmType
    func toSQLModel() -> SQLType
}

protocol DatabaseService {    
    func create<T: DatabaseMappable>(_ object: T) async throws
    func create<T: DatabaseMappable>(_ object: [T]) async throws
    func read<T: DatabaseMappable>() async throws -> [T]
}
