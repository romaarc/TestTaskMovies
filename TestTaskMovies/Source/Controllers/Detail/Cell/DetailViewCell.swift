//
//  DetailViewCell.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 11.11.2021.
//

import UIKit

final class DetailViewCell: BaseUITableViewCell {
    
    private let posterImageView: UIImageView = {
        let poster = UIImageView()
        poster.contentMode = .scaleAspectFill
        poster.clipsToBounds = true
        return poster
    }()
    
    private let detailView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let detailViewTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.textAlignment = .natural
        label.font = Font.okko(ofSize: Font.Size.fouthteen, weight: .regular)
        return label
    }()
    
    private let detailViewTaglineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = .zero
        label.textColor = Colors.lightWhite
        label.textAlignment = .natural
        label.font = Font.okko(ofSize: Font.Size.fouthteen, weight: .regular)
        return label
    }()
    
    override func setupView() {
        selectionStyle = .none
        backgroundColor = Colors.purpleMain
        [posterImageView, detailView].forEach { addSubview($0) }
        [detailViewTitleLabel, detailViewTaglineLabel].forEach { detailView.addSubview($0) }
        setupUI()
    }
}
//MARK: - UI
extension DetailViewCell {
    private func setupUI() {
        posterImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: .zero, left: .zero, bottom: DetailConstants.Layout.size, right: .zero))
       
        NSLayoutConstraint.activate([
            detailView.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: .zero),
            detailView.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: CGFloat(GlobalConstants.collectionCellHeight) - DetailConstants.Layout.size),
            detailView.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: .zero),
            detailView.heightAnchor.constraint(equalToConstant: DetailConstants.Layout.size)
        ])

        setupUIDetailViewTitleLabel()
        setupUIDetailViewTaglineLabel()
    }
    
    private func setupUIDetailViewTitleLabel() {
        NSLayoutConstraint.activate([
            detailViewTitleLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: GlobalConstants.margin - 13),
            detailViewTitleLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: GlobalConstants.margin),
            detailViewTitleLabel.widthAnchor.constraint(equalToConstant: DetailConstants.Layout.detailViewTitleLabelWidthAnchor),
            detailViewTitleLabel.heightAnchor.constraint(equalToConstant: DetailConstants.Layout.detailViewTitleLabelHeightAnchor)
        ])
    }
    
    private func setupUIDetailViewTaglineLabel() {
        NSLayoutConstraint.activate([
            detailViewTaglineLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 25),
            detailViewTaglineLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: GlobalConstants.margin),
            detailViewTaglineLabel.widthAnchor.constraint(equalToConstant: DetailConstants.Layout.detailViewTitleLabelWidthAnchor),
            detailViewTaglineLabel.heightAnchor.constraint(equalToConstant: DetailConstants.Layout.detailViewTitleLabelHeightAnchor)
        ])
    }
//MARK: - Updating ViewModel
    func update(with viewModel: MovieCardViewModel) {
        updatePosterView(with: viewModel)
        updateDetailView(with: viewModel)
    }
    
    func updatePosterView(with viewModel: MovieCardViewModel) {
        let url = URL(string: URLFactory.imageMovie() + viewModel.image.replacingOccurrences(of: "/", with: ""))
        posterImageView.setImage(with: url)
    }
    
    func updateDetailView(with viewModel: MovieCardViewModel) {
        var genre = ""
        if viewModel.genre.count > 0 {
            genre = viewModel.genre[0].name ?? ""
        } else {
            genre = ""
        }
        detailViewTaglineLabel.text = viewModel.tagline
        if !viewModel.productionCountry.isEmpty {
            detailViewTitleLabel.text = String().getYear(withDate: viewModel.date) +  GlobalConstants.circleText + viewModel.productionCountry + GlobalConstants.circleText + genre
        } else {
            detailViewTitleLabel.text = String().getYear(withDate: viewModel.date) + GlobalConstants.circleText + genre
        }
    }
}


