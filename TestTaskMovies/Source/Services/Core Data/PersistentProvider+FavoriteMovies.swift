//
//  PersistentProvider+FavoriteMovies.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 14.11.2021.
//

import Foundation
import CoreData

extension PersistentProvider: PersistentProviderProtocol {
    func update(with viewModel: MovieCardFavoriteViewModel?, withAction action: PersistentState, and completion: @escaping (Result<PersistentState, Error>) -> Void) {
        
        switch action  {
        case .add:
            guard let viewModel = viewModel else { return }
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: PersistentConstants.modelName)
            request.predicate =  NSPredicate(format: "id == %i", viewModel.id)
            if let favoriteMovies = try? viewContext.fetch(request) as? [FavoriteMovies], favoriteMovies.isEmpty {
                let fav = FavoriteMovies(context: viewContext)
                fav.id = NSNumber(value: viewModel.id).int64Value
                fav.isFavorite = viewModel.isFavorite
                fav.currentDate = Date().getGMTTimeDate()
                do {
                    try viewContext.save()
                    completion(.success(.add))
                } catch let error {
                    completion(.failure(error))
                }
            }
        case .update:
            guard let viewModel = viewModel else { return }
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: PersistentConstants.modelName)
            request.predicate =  NSPredicate(format: "id == %i", viewModel.id)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            do {
                try viewContext.execute(deleteRequest)
                completion(.success(.update))
            } catch let error as NSError {
                completion(.failure(error))
            }
        case .remove:
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: PersistentConstants.modelName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try viewContext.execute(deleteRequest)
                completion(.success(.remove))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
    }
    
    func requestModels() -> [FavoriteMovies] {
        let request = FavoriteMovies.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(FavoriteMovies.currentDate), ascending: true)
        request.sortDescriptors = [sort]
        let favoriteMovies = try? viewContext.fetch(request)
        guard let favoriteMovies = favoriteMovies else { return [FavoriteMovies]() }
        return favoriteMovies
    }
    
    func requestModels(withId id: Int) -> [FavoriteMovies] {
        let request = FavoriteMovies.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", id)
        let favoriteMovies = try? viewContext.fetch(request)
        guard let favoriteMovies = favoriteMovies else { return [FavoriteMovies]() }
        return favoriteMovies
    }
}
