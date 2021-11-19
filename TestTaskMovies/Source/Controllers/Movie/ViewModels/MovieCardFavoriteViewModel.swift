//
//  MovieCardFavoriteViewModel.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 13.11.2021.
//

import Foundation

struct MovieCardFavoriteViewModel {
    var id: Int
    var isFavorite: Bool
    
    mutating func changeValue(withId id: Int, with isFavorite: Bool) {
        self.id = id
        self.isFavorite = isFavorite
    }
}
