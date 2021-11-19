//
//  DetailViewDescriptionCell.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 11.11.2021.
//

import UIKit

final class DetailViewDescriptionCell: BaseUITableViewCell {
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.lightWhite
        label.textAlignment = .left
        label.font = Font.okko(ofSize: Font.Size.twenty, weight: .regular)
        label.numberOfLines = .zero
        return label
    }()
    
    override func setupView() {
        selectionStyle = .none
        backgroundColor = Colors.purpleMain
        addSubview(descriptionLabel)
    }
}

extension DetailViewDescriptionCell {
//MARK: - UI
    private func setupUI() {
        let size = UILabel.textSize(font: Font.okko(ofSize: Font.Size.twenty, weight: .regular), text: descriptionLabel.text ?? "", width: DetailConstants.Layout.descriptionLabelWidth)

        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            descriptionLabel.heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
//MARK: - Updating ViewModel
    func update(with viewModel: MovieCardViewModel) {
        descriptionLabel.text = viewModel.info
        setupUI()
    }
}



