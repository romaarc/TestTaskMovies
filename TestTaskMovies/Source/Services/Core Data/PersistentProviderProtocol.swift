//
//  PersistentProviderProtocol.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 14.11.2021.
//

import Foundation

protocol PersistentProviderProtocol {
    func update(with viewModel: MovieCardFavoriteViewModel?,
                withAction action: PersistentState,
             and completion: @escaping (Result<PersistentState, Error>) -> Void)
    
    func requestModels() -> [FavoriteMovies]
    func requestModels(withId id: Int) -> [FavoriteMovies]
}
