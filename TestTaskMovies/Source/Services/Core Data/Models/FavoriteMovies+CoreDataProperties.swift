//
//  FavoriteMovies+CoreDataProperties.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 15.11.2021.
//
//

import Foundation
import CoreData


extension FavoriteMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovies> {
        return NSFetchRequest<FavoriteMovies>(entityName: PersistentConstants.modelName)
    }

    @NSManaged public var id: Int64
    @NSManaged public var isFavorite: Bool
    @NSManaged public var currentDate: Date?

}

extension FavoriteMovies : Identifiable {

}
