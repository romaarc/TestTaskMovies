//
//  Font.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 06.11.2021.
//

import UIKit

enum Font {
    enum Size {
        static let twenty: CGFloat = 20.0
        static let twentyEight: CGFloat = 28.0
        static let fouthteen: CGFloat = 14.0
    }
    
    enum Weight {
        case regular, medium, bold
    }
    
    static func okko(ofSize size: CGFloat, weight: Weight) -> UIFont {
        switch weight {
        case .regular:
            return UIFont(name: "OKKOSans", size: size)!
        case .medium:
            return UIFont(name: "OKKOSans-Medium", size: size)!
        case .bold:
            return UIFont(name: "OKKOSans-DemiBold", size: size)!
        }
    }
}
