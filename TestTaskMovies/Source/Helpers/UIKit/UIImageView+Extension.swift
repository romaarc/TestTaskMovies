//
//  UIImageView+Extension.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 06.11.2021.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with url: URL?) {
        self.kf.setImage(with: url)
    }
}
