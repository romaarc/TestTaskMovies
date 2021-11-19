//
//  NetworkService+Movies.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 04.11.2021.
//
import Foundation

extension NetworkService: MovieNetworkProtocol {
    func requestImgMovieURL() -> String {
        URLFactory.imageMovie()
    }
    
    func requestMovies(with params: MovieURLParametrs, and completion: @escaping (Result<MovieResponse, Error>) -> Void) {
       
        let url = URLFactory.popularMovies(params: params)
        self.baseRequest(url: url, completion: completion)
    }
    
    func requestMoviesDetail(with params: MovieDetailURLParameters, withId id: Int, and completion: @escaping (Result<MovieDetailResponse, Error>) -> Void) {
        
        let url = URLFactory.getMovieDetail(params: params, with: id)
        self.baseRequest(url: url, completion: completion)
    }
}
