//
//  RealmDBClientImpl.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 22/10/2024.
//

import RealmSwift

//self.container.register(MovieDBClient.self) { r in
//    let realmImplementation = MovieRealmDatabase()
//    let databaseService = GenericDatabaseService(implementation: realmImplementation)
//    return RealmDBClientImplTest(dataBaseService: databaseService)
//}
//
//container.register(MovieLocalDataSource.self) { r in
//    MovieLocalDataSourceImpl(movieDBClient: r.resolve(MovieDBClient.self)!)
//}

protocol MovieDBClient {
    func saveMovies(_ movies: [MovieDataModel]) async throws
    func getMovies() async throws -> [MovieDataModel]
}

//class RealmDBClientImpl: MovieDBClient {
//    private let dataBaseService: any DatabaseService
//    
//    init(dataBaseService: any DatabaseService) {
//        self.dataBaseService = dataBaseService
//    }
//    
//    func saveMovies(_ movies: [MovieDataModel]) async throws {
//        try await self.dataBaseService.save(movies)
//    }
//    
//    func getMovies() async throws -> [MovieDataModel] {
//        try await self.dataBaseService.getAll()
//    }
//}

class RealmDBClientImplTest: MovieDBClient {
    private let dataBaseService: any DatabaseServiceTest<MovieDataModel>
    
    init<T: DatabaseServiceTest>(dataBaseService: T) where T.DataModel == MovieDataModel {
        self.dataBaseService = dataBaseService
    }
    
    func saveMovies(_ movies: [MovieDataModel]) async throws {
        try await dataBaseService.save(movies)
    }
    
    func getMovies() async throws -> [MovieDataModel] {
        try await dataBaseService.getAll()
    }
}

protocol DatabaseServiceTest<DataModel> {
    associatedtype DataModel
    
    func save(_ items: [DataModel]) async throws
    func getAll() async throws -> [DataModel]
}

protocol DatabaseImplementation {
    associatedtype StorageModel
    associatedtype DataModel
    
    func save(_ items: [DataModel]) throws
    func getAll() throws -> [StorageModel]
    
    func convert(dataModel: DataModel) -> StorageModel
    func convert(storageModel: StorageModel) -> DataModel
}

// MARK: - Generic Database Service
class GenericDatabaseService<Implementation: DatabaseImplementation>: DatabaseServiceTest {
    typealias DataModel = Implementation.DataModel
    
    private let implementation: Implementation
    
    init(implementation: Implementation) {
        self.implementation = implementation
    }
    
    func save(_ items: [Implementation.DataModel]) async throws {
        try implementation.save(items)
    }
    
    func getAll() async throws -> [Implementation.DataModel] {
        let storageModels = try implementation.getAll()
        return storageModels.map { implementation.convert(storageModel: $0) }
    }
}

protocol RealmObjectConvertible: Object {
    associatedtype DataType
    
    func toDataModel() -> DataType
}

protocol DataModelConvertible {
    associatedtype RealmType: RealmObjectConvertible
    
    func toRealmModel() -> RealmType
}

// MARK: - Realm Implementation
class RealmDatabaseImplementation<StorageType: RealmObjectConvertible, DataType: DataModelConvertible>: DatabaseImplementation where StorageType.DataType == DataType, DataType.RealmType == StorageType {
    typealias StorageModel = StorageType
    typealias DataModel = DataType
    
    private let queue = DispatchQueue(label: "com.realm.service.queue", qos: .background)
    private let configuration: Realm.Configuration
    
    init(configuration: Realm.Configuration = .defaultConfiguration) {
        self.configuration = configuration
    }
    
    private func getRealm() throws -> Realm {
        do {
            return try Realm(configuration: configuration)
        } catch {
            throw DatabaseError.invalidDataType
        }
    }
    
    func save(_ items: [DataModel]) throws where DataModel: DataModelConvertible, DataModel.RealmType == StorageType {
        do {
            let realm = try getRealm()
            try realm.write {
                items.forEach { item in
                    realm.add(convert(dataModel: item), update: .modified)
                }
            }
        } catch {
            throw DatabaseError.saveFailed
        }
    }
    
    func getAll() throws -> [StorageModel] {
        do {
            let realm = try getRealm()
            return Array(realm.objects(StorageType.self))
        } catch {
            throw DatabaseError.fetchFailed
        }
    }
    
    func convert(dataModel: DataModel) -> StorageModel where DataModel: DataModelConvertible, DataModel.RealmType == StorageType {
        dataModel.toRealmModel()
    }
    
    func convert(storageModel: StorageModel) -> DataModel {
        storageModel.toDataModel()
    }
}

// MARK: - Error Handling
enum DatabaseError: Error {
    case invalidDataType
    case saveFailed
    case fetchFailed
}

//extension MovieDataModel: DataModelConvertible {
//    typealias RealmType = MovieRealmModel
//    
//    func toRealmModel() -> MovieRealmModel {
//        let realmMovie = MovieRealmModel()
//        realmMovie.id = id
//        realmMovie.title = title
//        realmMovie.popularity = popularity
//        realmMovie.posterPath = posterPath
//        return realmMovie
//    }
//    
////    func toRealmModel() -> MovieSQLModel {
////        MovieSQLModel(
////            id: id,
////            title: title
////        )
////    }
//}

//typealias MovieRealmDatabase = RealmDatabaseImplementation<MovieRealmModel, MovieDataModel>

// ------------

//// MARK: - Database Service Protocol
//protocol DatabaseServiceTest {
//    associatedtype Model
//    func save<T>(_ items: [T]) async throws
//    func getAll<T>() async throws -> [T]
//}
//
//protocol DatabaseImplementation {
//    associatedtype StorageModel
//    associatedtype DataModel
//    
//    func save(_ items: [DataModel]) throws
//    func getAll() throws -> [StorageModel]
//    
//    // Conversion methods
//    func convert(dataModel: DataModel) -> StorageModel
//    func convert(storageModel: StorageModel) -> DataModel
//}
//
//// MARK: - Generic Database Service
//class GenericDatabaseService<Implementation: DatabaseImplementation>: DatabaseServiceTest {
//    private let implementation: Implementation
//    
//    init(implementation: Implementation) {
//        self.implementation = implementation
//    }
//    
//    func save<T>(_ items: [T]) async throws {
//        guard let items = items as? [Implementation.DataModel] else {
//            throw DatabaseError.invalidDataType
//        }
//        
//        try implementation.save(items)
//    }
//    
//    func getAll<T>() async throws -> [T] {
//        let storageModels = try implementation.getAll()
//        let dataModels = storageModels.map { implementation.convert(storageModel: $0) }
//        
//        guard let results = dataModels as? [T] else {
//            throw DatabaseError.invalidDataType
//        }
//        
//        return results
//    }
//}
//
//// MARK: - Realm Implementation
//class RealmDatabaseImplementation: DatabaseImplementation {
//    typealias StorageModel = MovieRealmModel
//    typealias DataModel = MovieDataModel
//    
//    private let realm: Realm
//    
//    init(realm: Realm) {
//        self.realm = realm
//    }
//    
//    func save(_ items: [MovieDataModel]) throws {
//        try realm.write {
//            items.forEach { movie in
//                realm.add(convert(dataModel: movie), update: .modified)
//            }
//        }
//    }
//    
//    func getAll() throws -> [MovieRealmModel] {
//        Array(realm.objects(MovieRealmModel.self))
//    }
//    
//    func convert(dataModel: MovieDataModel) -> MovieRealmModel {
//        dataModel.toRealmModel()
//    }
//    
//    func convert(storageModel: MovieRealmModel) -> MovieDataModel {
//        storageModel.toDataModel()
//    }
//}
//
//// MARK: - Updated RealmDBClientImplTest
//class RealmDBClientImplTest: MovieDBClient {
//    private let dataBaseService: any DatabaseServiceTest
//    
//    init(dataBaseService: any DatabaseServiceTest) {
//        self.dataBaseService = dataBaseService
//    }
//    
//    func saveMovies(_ movies: [MovieDataModel]) async throws {
//        try await dataBaseService.save(movies)
//    }
//    
//    func getMovies() async throws -> [MovieDataModel] {
//        try await dataBaseService.getAll()
//    }
//}
//
//enum DatabaseError: Error {
//    case invalidDataType
//    case saveFailed
//    case fetchFailed
//}
//
//// MARK: - Usage Example
//extension RealmDBClientImplTest {
//    static func createDefault() -> RealmDBClientImplTest {
//        let realm = try! Realm()
//        let realmImplementation = RealmDatabaseImplementation(realm: realm)
//        let databaseService = GenericDatabaseService(implementation: realmImplementation)
//        return RealmDBClientImplTest(dataBaseService: databaseService)
//    }
//}
