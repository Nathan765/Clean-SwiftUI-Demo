//
//  ActorDetailsApiResponse+Mapper.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 23/10/2024.
//

extension ActorDetailsApiResponse {
    func toDataModel() -> ActorDataModel? {
        ActorDataModel(
            id: id ?? 666,
            name: name ?? "name",
            profilePath: profilePath ?? ""
        )
    }
}
