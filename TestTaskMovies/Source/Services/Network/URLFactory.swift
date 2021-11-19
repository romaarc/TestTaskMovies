//
//  URLFactory.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 04.11.2021.
//

import Foundation

enum URLFactory {
    private static let apiKey = APIConstants.v3Key
    
    private static var baseURL: URL {
        return baseURLComponents.url!
    }
    private static let baseURLComponents: URLComponents = {
        let url = URL(string: APIConstants.moviesURL)!
        let queryItem = URLQueryItem(name: "api_key", value: URLFactory.apiKey)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [queryItem]
        return urlComponents
    }()
    
    static func popularMovies(params: MovieURLParametrs) -> String {
        let params = [URLQueryItem(name: "language", value: "\(params.language)"),
                      URLQueryItem(name: "page", value: "\(params.page)")]
        var urlComponents = baseURLComponents
        urlComponents.queryItems?.append(contentsOf: params)
        return urlComponents.url!.appendingPathComponent(MovieAPIType.popular).absoluteString
    }
    
    static func getMovieDetail(params: MovieDetailURLParameters, with id: Int) -> String {
        let params = [URLQueryItem(name: "language", value: "\(params.language)")]
        var urlComponents = baseURLComponents
        urlComponents.queryItems?.append(contentsOf: params)
        return urlComponents.url!.appendingPathComponent("\(id)").absoluteString
    }
    
    static func imageMovie() -> String {
        return APIConstants.imageURL
    }
}
