//
//  RealmDatabaseServiceImpl.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 22/10/2024.
//

import RealmSwift

class RealmDatabaseServiceImpl: DatabaseService {
    // MARK: - Properties
    private let queue = DispatchQueue(label: "com.realm.service.queue", qos: .background)
    private let configuration: Realm.Configuration
    
    // MARK: - Initialization
    init(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Private Methods
    private func getRealm() throws -> Realm {
        do {
            return try Realm(configuration: configuration)
        } catch {
            throw DataBaseError.RealmServiceError.initializationError
        }
    }
    
    func create<T: DatabaseMappable>(_ object: T) async throws {
        try await withCheckedThrowingContinuation { continuation in
            queue.async {
                do {
                    let realm = try self.getRealm()
                    try realm.write {
                        let model = object.toRealmModel()
                        realm.add(model, update: .modified)
                    }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: DataBaseError.RealmServiceError.writeError)
                }
            }
        }
}
    
    func create<T: DatabaseMappable>(_ object: [T]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            queue.async {
                do {
                    let realm = try self.getRealm()
                    try realm.write {
                        let model = object.map { $0.toRealmModel() }
                        realm.add(model, update: .modified)
                    }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: DataBaseError.RealmServiceError.writeError)
                }
            }
        }
    }
    
    func read<T: DatabaseMappable>() async throws -> [T] {
        try await withCheckedThrowingContinuation { continuation in
            queue.async {
                do {
                    let realm = try self.getRealm()
                    let realmModels = realm.objects(T.RealmType.self)
                    let dataModels = realmModels.map { $0.toDataModel() }
                    continuation.resume(returning: Array(dataModels))
                } catch {
                    continuation.resume(throwing: DataBaseError.RealmServiceError.readError)
                }
            }
        }
    }
    
//    private func getAll2() async throws -> [MovieDataModel] {
//        try await Task {
//            //            do {
//            let realm = try getRealm()
//            let realmModels = realm.objects(MovieRealmModel.self)
//            let dataModels = realmModels.map {$0.toDataModel()}
//            return Array(dataModels)
//            //            } catch {
//            //                throw DataBaseError.RealmServiceError.readError
//            //            }
//        }.value
//    }
    
//    func deleteAll() async throws {
//        try await withCheckedThrowingContinuation { continuation in
//            queue.async {
//                do {
//                    let realm = try self.getRealm()
//                    try realm.write {
//                        realm.deleteAll()
//                    }
//                    continuation.resume()
//                } catch {
//                    continuation.resume(throwing: DataBaseError.RealmServiceError.deleteError)
//                }
//            }
//        }
//    }
}

//actor RealmServiceActor: DatabaseService {
//    // MARK: - Properties
//    private let configuration: Realm.Configuration
//    
//    // MARK: - Initialization
//    init(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
//        self.configuration = configuration
//    }
//    
//    // MARK: - Private Methods
//    private func getRealm() throws -> Realm {
//        do {
//            return try Realm(configuration: configuration)
//        } catch {
//            throw DataBaseError.RealmServiceError.initializationError
//        }
//    }
//    
//    func save(_ movie: MovieDataModel) async throws {
//        do {
//            let realm = try getRealm()
//            try realm.write {
//                let realmModel = movie.toRealmModel()
//                realm.add(realmModel, update: .modified)
//            }
//        } catch {
//            throw DataBaseError.RealmServiceError.writeError
//        }
//    }
//    
//    func save(_ movies: [MovieDataModel]) async throws {
//        do {
//            let realm = try getRealm()
//            try realm.write {
//                let realmMovies = movies.map { $0.toRealmModel() }
//                realm.add(realmMovies, update: .modified)
//            }
//        } catch {
//            throw DataBaseError.RealmServiceError.writeError
//        }
//    }
//    
//    func getAll() async throws -> [MovieDataModel] {
//        do {
//            let realm = try getRealm()
//            let realmModels = realm.objects(MovieRealmModel.self)
//            let dataModels = realmModels.map { $0.toDataModel() }
//            return Array(dataModels)
//        } catch {
//            throw DataBaseError.RealmServiceError.readError
//        }
//    }
//    
//    func deleteAll() async throws {
//        do {
//            let realm = try getRealm()
//            try realm.write {
//                realm.deleteAll()
//            }
//        } catch {
//            throw DataBaseError.RealmServiceError.deleteError
//        }
//    }
//}
