//
//  MovieNetworkServiceProtocol.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 04.11.2021.
//

import Foundation

protocol MovieNetworkProtocol {
    func requestMovies(with params: MovieURLParametrs, and completion: @escaping (Result<MovieResponse, Error>) -> Void)
    func requestImgMovieURL() -> String
    func requestMoviesDetail(with params: MovieDetailURLParameters, withId id: Int, and completion: @escaping (Result<MovieDetailResponse, Error>) -> Void)
}
