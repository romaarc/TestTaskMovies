//
//  Cacher.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 15.11.2021.
//

import Kingfisher
import UIKit

extension UIImageView {
    func setupCache() {
        let cache = ImageCache.default
        // Limit memory cache size to 100 MB.
        cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024

        // Limit memory cache to hold 150 images at most.
        cache.memoryStorage.config.countLimit = 150
        
        // Limit disk cache size to 200 MB.
        cache.diskStorage.config.sizeLimit = 200 * 1024 * 1024
        
        // Memory image expires after 20 sec.
        cache.memoryStorage.config.expiration = .seconds(20)
    }
}
