//
//  PopularActorsApiResponse+Mapper.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 23/10/2024.
//

extension PopularActorsApiResponse {
    func toDataModels() -> [ActorDataModel]? {
        actors?.map {
            ActorDataModel(
                id: $0.id ?? 666,
                name: $0.name ?? "name",
                profilePath: $0.profilePath ?? ""
            )
        }
    }
}
