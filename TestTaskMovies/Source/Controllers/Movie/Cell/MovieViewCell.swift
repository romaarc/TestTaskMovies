//
//  MovieViewCell.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 05.11.2021.
//

import UIKit

protocol MovieViewCellDelegate: AnyObject {
    func didPressStarButton(withRow indexPath: IndexPath, and favModel: MovieCardFavoriteViewModel?)
}

final class MovieViewCell: UICollectionViewCell {
    
    weak var delegate : MovieViewCellDelegate?
    var starButtonTapDelegate: VoidClosure?
    private var indexPath: IndexPath?
    var favoriteModel: MovieCardFavoriteViewModel?
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = MovieConstants.Layout.labelCornerRadius
        label.layer.borderWidth = MovieConstants.Layout.labelBorderWidth
        label.layer.backgroundColor = Colors.purpleLabel.cgColor
        label.layer.borderColor = Colors.purpleLabel.cgColor
        label.layer.masksToBounds = true
        return label
    }()
    
    private let freeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = MovieConstants.Layout.labelCornerRadius
        label.layer.borderWidth = MovieConstants.Layout.labelBorderWidth
        label.layer.backgroundColor = Colors.pinkLabel.cgColor
        label.layer.borderColor = Colors.pinkLabel.cgColor
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var posterImageView: UIImageView = {
        let poster = UIImageView()
        poster.contentMode = .scaleAspectFill
        return poster
    }()
    
    private lazy var starButton: UIButton = {
        let button = UIButton()
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: MovieConstants.Layout.starButtonImageInsets, left: MovieConstants.Layout.starButtonImageInsets, bottom: MovieConstants.Layout.starButtonImageInsets, right: MovieConstants.Layout.starButtonImageInsets)
        button.addTarget(self, action: #selector(didTapOnStarButton), for: .touchUpInside)
        button.setImage(MovieConstants.Images.starButton, for: .normal)
        return button
    }()
    
    private let detailView = GradientView()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension MovieViewCell {
    private func setupView() {
        [posterImageView, starButton].forEach { addSubview($0) }
        [ratingLabel, freeLabel, detailView].forEach { posterImageView.addSubview($0) }
        [detailViewTitleLabel, detailViewTaglineLabel].forEach { detailView.addSubview($0) }
        layer.cornerRadius = MovieConstants.Layout.cornerRadius
        layer.masksToBounds = true
        setupUI()
    }
//MARK: - UI
    private func setupUI() {
        let size = MovieConstants.Layout.size
        
        posterImageView.frame = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height - size)
        
        setupUIRatingLabel(size: size, fontSize: Font.Size.fouthteen, x: GlobalConstants.margin, y: GlobalConstants.margin)
        setupUIFreeLabel(size: size, fontSize: Font.Size.fouthteen, x: GlobalConstants.margin, y: GlobalConstants.margin)
        setupUIStarButton(size: size, x: bounds.width - GlobalConstants.margin * 4, y: GlobalConstants.margin)

        switch UIDevice().type {
        case .iPhone13Pro, .iPhone13Mini, .iPhone13:
            detailView.frame = CGRect(x: .zero, y: posterImageView.bounds.height, width: bounds.width, height: size)
        case .iPhone13ProMax:
            detailView.frame = CGRect(x: .zero, y: CGFloat(GlobalConstants.collectionCellHeight) - size, width: bounds.width, height: size)
        default:
            detailView.frame = CGRect(x: .zero, y: posterImageView.bounds.height, width: bounds.width, height: size)
        }

        setupUIDetailViewTitleLabel()
        setupUIDetailViewTaglineLabel()
    }
    
    private func setupUIRatingLabel(size: CGFloat, fontSize: CGFloat, x: CGFloat, y: CGFloat) {
        let font = Font.okko(ofSize: fontSize, weight: .bold)
        let ratingLabelSize = UILabel.textSize(font: font, text: GlobalConstants.raitingSlogan)
       
        ratingLabel.frame.size = ratingLabelSize
        ratingLabel.font = font
        ratingLabel.frame.origin = CGPoint(x: GlobalConstants.margin, y: GlobalConstants.margin)
        ratingLabel.layer.frame = CGRect(x: GlobalConstants.margin,
                                         y: GlobalConstants.margin,
                                         width: ratingLabelSize.width + 42,
                                         height: ratingLabelSize.height + 7)
        
    }
    
    private func setupUIFreeLabel(size: CGFloat, fontSize: CGFloat, x: CGFloat, y: CGFloat) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = MovieConstants.Images.playButton
        let imageOffsetY: CGFloat = -5.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let textAfterIcon = NSAttributedString(string: MovieConstants.Layout.freeSlogan)
        completeText.append(textAfterIcon)
        freeLabel.attributedText = completeText
        
        let font = Font.okko(ofSize: fontSize, weight: .bold)
        let freeLabelSize = UILabel.textSize(font: font, text: completeText.string + "     ")
        freeLabel.frame.size = freeLabelSize
        freeLabel.font = font
        freeLabel.frame.origin = CGPoint(x: GlobalConstants.margin, y: GlobalConstants.margin)
        freeLabel.layer.frame = CGRect(x: ratingLabel.frame.width + 22, y: freeLabel.frame.minY, width: freeLabel.frame.width + 14, height: freeLabel.frame.height + 7)
    }
    
    private func setupUIStarButton(size: CGFloat, x: CGFloat, y: CGFloat) {
        starButton.frame = CGRect(x:  x, y:  y, width: size, height: size)
    }
    
    @objc private func didTapOnStarButton(sender: UIButton) {
        guard let row = indexPath else { return }
        delegate?.didPressStarButton(withRow: row, and: favoriteModel)
        if let fav = favoriteModel {
            if fav.isFavorite {
                starButton.setImage(MovieConstants.Images.starFillButton, for: .normal)
            }
        } else {
            starButton.setImage(MovieConstants.Images.starButton, for: .normal)
        }
        starButtonTapDelegate?()
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
//MARK: - Update with ViewModel
    func update(with viewModel: MovieCardViewModel, withRow row: IndexPath, with favorites: [Int: MovieCardFavoriteViewModel]) {
        indexPath = row
        favoriteModel = favorites[viewModel.id]
        updateStarButtonImage(withId: viewModel.id, withViewModel: favoriteModel)
        updatePosterView(with: viewModel)
        updateDetailView(with: viewModel)
    }
    
    func updateStarButtonImage(withId id: Int, withViewModel favorite: MovieCardFavoriteViewModel?) {
        if let fav = favorite {
            if fav.id == id, fav.isFavorite {
                starButton.setImage(MovieConstants.Images.starFillButton, for: .normal)
            } else {
                starButton.setImage(MovieConstants.Images.starButton, for: .normal)
            }
        } else {
            starButton.setImage(MovieConstants.Images.starButton, for: .normal)
        }
    }
    
    func updatePosterView(with viewModel: MovieCardViewModel) {
        ratingLabel.text = " " + viewModel.rating + " "
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


