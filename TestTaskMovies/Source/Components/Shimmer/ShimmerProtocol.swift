//
//  ShimmerProtocol.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 18.11.2021.
//

import UIKit

protocol ShimmerProtocol: UIView {
    var gradientLayer: CAGradientLayer { get set }
}

extension ShimmerProtocol {
    func startShimmerAnimation() {
        let gradientColorOne: CGColor = Colors.Gradient.topColor.cgColor
        let gradientColorTwo: CGColor = Colors.Gradient.midColor.cgColor

        gradientLayer.frame = self.bounds
        gradientLayer.name = "Shimmer"
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]

        let animation = CABasicAnimation(keyPath: "locations")
        animation.duration = 0.9
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: animation.keyPath)

        self.layer.addSublayer(gradientLayer)
    }

    func removeShimmerAnimation() {
        gradientLayer.removeFromSuperlayer()
    }
}

