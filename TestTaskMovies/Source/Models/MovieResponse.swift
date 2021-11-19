//
//  MovieResponse.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 04.11.2021.
//

import Foundation

struct MovieResponse: Decodable {
    let data: [Movie]
    let page: Int?
    let totalResult: Int?
    let totalPages: Int?
    
    private enum CodingKeys: String, CodingKey {
        case page
        case data = "results"
        case totalResult = "total_results"
        case totalPages = "total_pages"
    }
}

struct Movie: Decodable {
    let title: String?
    let year: String?
    let rate: Double?
    let posterImage: String?
    let overview: String?
    let id: Int?
    
    private enum CodingKeys: String, CodingKey {
        case title, overview, id
        case year = "release_date"
        case rate = "vote_average"
        case posterImage = "poster_path"
    }
}

struct MovieURLParametrs {
    let language: String = "ru-RU"
    let page: Int
}
