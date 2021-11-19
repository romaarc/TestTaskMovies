//
//  FavoriteViewCell.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 14.11.2021.
//

import UIKit

final class FavoriteViewCell: BaseUITableViewCell {

    private lazy var posterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = FavoriteConstants.Layout.cornerRadius
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var posterView: GradientView = {
        let gradientView = GradientView()
        gradientView.layer.cornerRadius = FavoriteConstants.Layout.cornerRadius
        gradientView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        gradientView.layer.masksToBounds = true
        return gradientView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = .zero
        label.textColor = Colors.lightWhite
        label.textAlignment = .natural
        label.font = Font.okko(ofSize: Font.Size.twenty, weight: .regular)
        label.baselineAdjustment = .alignCenters
        return label
    }()
    
    override func setupView() {
        selectionStyle = .none
        backgroundColor = Colors.purpleMain
        [posterImageView, posterView, titleLabel].forEach { addSubview($0) }
        setupUI()
    }
}

extension FavoriteViewCell {
//MARK: - UI
    private func setupUI() {
        posterImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: FavoriteConstants.Layout.tenSpace, left: FavoriteConstants.Layout.tenSpace, bottom: FavoriteConstants.Layout.tenSpace, right: FavoriteConstants.Layout.tenSpace))
        
        posterView.anchor(top: posterImageView.topAnchor, leading: posterImageView.leadingAnchor, bottom: posterImageView.bottomAnchor, trailing: posterImageView.trailingAnchor, padding: UIEdgeInsets(top: FavoriteConstants.Layout.posterViewTopAnchor, left: .zero, bottom: .zero, right: .zero))

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: posterView.leadingAnchor, constant: FavoriteConstants.Layout.tenSpace),
            titleLabel.topAnchor.constraint(equalTo: posterView.topAnchor, constant: FavoriteConstants.Layout.fifteenSpace),
            titleLabel.trailingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: FavoriteConstants.Layout.titleTrailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: FavoriteConstants.Layout.titleHeightAnchor)
        ])
    }
//MARK: - Update with ViewModel
    func update(with viewModel: FavoriteViewModel) {
        let url = URL(string: URLFactory.imageMovie() + viewModel.image.replacingOccurrences(of: "/", with: ""))
        posterImageView.setImage(with: url)
        titleLabel.text = String().getYear(withDate: viewModel.releaseDate) + GlobalConstants.circleText + viewModel.title
    }
}
