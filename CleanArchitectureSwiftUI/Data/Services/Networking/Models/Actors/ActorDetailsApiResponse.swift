//
//  ActorDetailsApiResponse.swift
//  
//
//  Created by Nathan Stéphant on 23/10/2024.
//

typealias ActorDetailsApiResponses = [ActorDetailsApiResponse]

struct ActorDetailsApiResponse: Decodable {
    let id: Int?
    let name: String?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case profilePath = "profile_path"
    }
}

