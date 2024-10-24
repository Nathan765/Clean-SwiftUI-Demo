//
//  HomeSceneConfigurator.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 19/10/2024.
//

import Swinject
import RealmSwift

class HomeSceneConfigurator {
    static private let container = Container()
    
    static func configureView() -> HomeSceneViewModelImpl {
        registerDependencies()
        
        return buildViewModel()
        
        func registerDependencies() {
            registerServices()
            registerDataSources()
            registerRepositories()
            registerUseCases()
            registerViewModels()
            
            func registerServices() {
                self.container.register(NetworkService.self) { _ in MoyaNetworkServiceImpl() }
                self.container.register(DatabaseService.self) { _ in RealmDatabaseServiceImpl() }
            }
            
            func registerDataSources() {
                container.register(MovieLocalDataSource.self) { r in
                    MovieLocalDataSourceImpl(databaseService: r.resolve((any DatabaseService).self)!)
                }
                
                container.register(ActorLocalDataSource.self) { r in
                    ActorLocalDataSourceImpl(databaseService: r.resolve((any DatabaseService).self)!)
                }
                
                container.register(MovieRemoteDataSource.self) { r in
                    MovieRemoteDataSourceImpl(networkService: r.resolve(NetworkService.self)!)
                }
                
                container.register(ActorRemoteDataSource.self) { r in
                    ActorRemoteDataSourceImpl(networkService: r.resolve(NetworkService.self)!)
                }
            }
            
            func registerRepositories() {
                container.register(MovieRepository.self) { r in
                    MovieRepositoryImpl(localDataSource: r.resolve(MovieLocalDataSource.self)!,
                                        remoteDataSource: r.resolve(MovieRemoteDataSource.self)!
                    )
                }
                
                container.register(ActorRepository.self) { r in
                    ActorRepositoryImpl(localDataSource: r.resolve(ActorLocalDataSource.self)!,
                                        remoteDataSource: r.resolve(ActorRemoteDataSource.self)!
                    )
                }
            }
            
            func registerUseCases() {
                movieUseCases()
                actorUseCases()
                
                func movieUseCases() {
                    container.register(UpcomingMoviesUseCase.self) { r in
                        UpcomingMoviesUseCaseImpl(movieRepository: r.resolve(MovieRepository.self)!)
                    }
                    
                    container.register(TopRatedMoviesUseCase.self) { r in
                        TopRatedMoviesUseCaseImpl(movieRepository: r.resolve(MovieRepository.self)!)
                    }
                    
                    container.register(PopularMoviesUseCase.self) { r in
                        PopularMoviesUseCaseImpl(movieRepository: r.resolve(MovieRepository.self)!)
                    }
                }
                
                func actorUseCases() {
                    container.register(ActorDetailsUseCase.self) { r in
                        ActorDetailsUseCaseImpl(repository: r.resolve(ActorRepository.self)!)
                    }
                    
                    container.register(PopularActorsUseCase.self) { r in
                        PopularActorsUseCaseImpl(repository: r.resolve(ActorRepository.self)!)
                    }
                }
            }
            
            func registerViewModels() {
                container.register((any HomeSceneViewModel).self) { r in
                    HomeSceneViewModelImpl(upcomingMoviesUseCase: r.resolve(UpcomingMoviesUseCase.self)!,
                                           topRatedMoviesUseCase: r.resolve(TopRatedMoviesUseCase.self)!,
                                           popularMoviesUseCase: r.resolve(PopularMoviesUseCase.self)!,
                                           popularActorsUseCase: r.resolve(PopularActorsUseCase.self)!
                    )
                }
                
                container.register(HomeSceneViewModelImpl.self) { r in
                    r.resolve((any HomeSceneViewModel).self) as! HomeSceneViewModelImpl
                }
            }
        }
        
        func buildViewModel() -> HomeSceneViewModelImpl {
            container.resolve(HomeSceneViewModelImpl.self)!
        }
    }
}


class SearchSceneConfigurator {
    static private let container = Container()
    
    static func configureView() -> SearchViewModelImpl {
        registerDependencies()
        
        return buildViewModel()
        
        func registerDependencies() {
            registerServices()
            registerDataSources()
            registerRepositories()
            registerUseCases()
            registerViewModels()
            
            func registerServices() {
                self.container.register(NetworkService.self) { _ in MoyaNetworkServiceImpl() }
                self.container.register(DatabaseService.self) { _ in RealmDatabaseServiceImpl() }
            }
            
            func registerDataSources() {
                container.register(MovieLocalDataSource.self) { r in
                    MovieLocalDataSourceImpl(databaseService: r.resolve((any DatabaseService).self)!)
                }
                
                container.register(ActorLocalDataSource.self) { r in
                    ActorLocalDataSourceImpl(databaseService: r.resolve((any DatabaseService).self)!)
                }
                
                container.register(MovieRemoteDataSource.self) { r in
                    MovieRemoteDataSourceImpl(networkService: r.resolve(NetworkService.self)!)
                }
                
                container.register(ActorRemoteDataSource.self) { r in
                    ActorRemoteDataSourceImpl(networkService: r.resolve(NetworkService.self)!)
                }
            }
            
            func registerRepositories() {
                container.register(MovieRepository.self) { r in
                    MovieRepositoryImpl(localDataSource: r.resolve(MovieLocalDataSource.self)!,
                                        remoteDataSource: r.resolve(MovieRemoteDataSource.self)!
                    )
                }
                
                container.register(ActorRepository.self) { r in
                    ActorRepositoryImpl(localDataSource: r.resolve(ActorLocalDataSource.self)!,
                                        remoteDataSource: r.resolve(ActorRemoteDataSource.self)!
                    )
                }
            }
            
            func registerUseCases() {
                movieUseCases()
                actorUseCases()
                
                func movieUseCases() {
                    container.register(UpcomingMoviesUseCase.self) { r in
                        UpcomingMoviesUseCaseImpl(movieRepository: r.resolve(MovieRepository.self)!)
                    }
                    
                    container.register(TopRatedMoviesUseCase.self) { r in
                        TopRatedMoviesUseCaseImpl(movieRepository: r.resolve(MovieRepository.self)!)
                    }
                    
                    container.register(PopularMoviesUseCase.self) { r in
                        PopularMoviesUseCaseImpl(movieRepository: r.resolve(MovieRepository.self)!)
                    }
                }
                
                func actorUseCases() {
                    container.register(ActorDetailsUseCase.self) { r in
                        ActorDetailsUseCaseImpl(repository: r.resolve(ActorRepository.self)!)
                    }
                    
                    container.register(PopularActorsUseCase.self) { r in
                        PopularActorsUseCaseImpl(repository: r.resolve(ActorRepository.self)!)
                    }
                }
            }
            
            func registerViewModels() {
                container.register((any SearchViewModel).self) { r in
                    SearchViewModelImpl(upcomingMoviesUseCase: r.resolve(UpcomingMoviesUseCase.self)!,
                                           topRatedMoviesUseCase: r.resolve(TopRatedMoviesUseCase.self)!,
                                           popularMoviesUseCase: r.resolve(PopularMoviesUseCase.self)!
                    )
                }
                
                container.register(SearchViewModelImpl.self) { r in
                    r.resolve((any SearchViewModel).self) as! SearchViewModelImpl
                }
            }
        }
        
        func buildViewModel() -> SearchViewModelImpl {
            container.resolve(SearchViewModelImpl.self)!
        }
    }
}
