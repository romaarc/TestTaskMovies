//
//  MovieDetailResponse.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 08.11.2021.
//

import Foundation

struct MovieDetailResponse: Decodable {
    let id: Int?
    let backdropPath: String?
    let genres: [Genres]?
    let productionCountries: [ProductionCountries]?
    let tagline: String?
    let title: String?
    let releaseDate: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, genres, tagline, title
        case productionCountries = "production_countries"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
    }
}

struct Genres: Decodable {
    let id: Int?
    let name: String?
}

struct ProductionCountries: Decodable {
    let name: String?
}

struct MovieDetailURLParameters {
    let language: String = "ru-RU"
}
