//
//  APIConstants.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 04.11.2021.
//

import Foundation

enum APIConstants {
    static let moviesURL = "https://api.themoviedb.org/3/movie/"
    static let v3Key = "0d439247f112dfd0969172681a4472eb"
    static let imageURL = "https://image.tmdb.org/t/p/w500/"
}

enum MovieAPIType {
    static let popular = "popular"
}

enum LoadingDataType {
    case nextPage
    case reload
}

