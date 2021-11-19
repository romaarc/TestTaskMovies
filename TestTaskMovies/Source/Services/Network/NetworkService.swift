//
//  NetworkService.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 04.11.2021.
//

import Foundation

enum NetworkError: Error {
    case wrongURL
    case dataIsEmpty
    case decodeIsFail
}

final class NetworkService {
    
    func baseRequest<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.failure(NetworkError.wrongURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.dataIsEmpty))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedModel = try decoder.decode(T.self, from: data)
                    completion(.success(decodedModel))
            } catch {
                    completion(.failure(NetworkError.decodeIsFail))
            }
            
        }.resume()
    }
}

