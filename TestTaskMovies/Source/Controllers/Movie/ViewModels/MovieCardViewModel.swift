//
//  MovieCardViewModel.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 05.11.2021.
//

import Foundation

struct MovieCardViewModel {
    let rating: String
    let image: String
    let info: String
    let date: String
    let id: Int
    let genre: [Genres]
    let productionCountry: String
    let tagline: String
}
