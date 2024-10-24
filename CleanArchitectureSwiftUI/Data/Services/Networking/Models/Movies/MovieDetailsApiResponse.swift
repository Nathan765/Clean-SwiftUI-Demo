//
//  MovieDetailsApiResponse.swift
//  CleanArchitectureSwiftUI
//
//  Created by Nathan Stéphant on 17/10/2024.
//

typealias MovieDetailsApiResponses = [MovieDetailsApiResponse]

struct MovieDetailsApiResponse: Decodable {
    let id: Int?
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let imdbId, originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbId = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    // MARK: - Genre
    struct Genre: Decodable {
        let id: Int?
        let name: String?
    }
    
    // MARK: - ProductionCompany
    struct ProductionCompany: Decodable {
        let id: Int?
        let logoPath, name, originCountry: String?
        
        enum CodingKeys: String, CodingKey {
            case id, name
            case logoPath = "logo_path"
            case originCountry = "origin_country"
        }
    }
    
    // MARK: - ProductionCountry
    struct ProductionCountry: Decodable {
        let name, iso3166_1: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case iso3166_1 = "iso_3166_1"
        }
    }
    
    // MARK: - BelongsToCollection
    struct BelongsToCollection: Decodable {
        let id: Int?
        let name, posterPath, backdropPath: String?
        
        enum CodingKeys: String, CodingKey {
            case id, name
            case posterPath = "poster_path"
            case backdropPath = "backdrop_path"
        }
    }
    
    // MARK: - SpokenLanguage
    struct SpokenLanguage: Decodable {
        let englishName, iso639_1, name: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case englishName = "english_name"
            case iso639_1 = "iso_639_1"
        }
    }
}
