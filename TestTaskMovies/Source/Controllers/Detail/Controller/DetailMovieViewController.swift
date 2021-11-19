//
//  DetailMovieViewController.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 07.11.2021.
//

import UIKit

final class DetailMovieViewController: UIViewController {
    
    var dismissHandler: VoidClosure?
    var viewModel: MovieCardViewModel?
    
    lazy var tableView = UITableView(frame: .zero, style: .plain)
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        let image = DetailConstants.Images.closeButtonImage
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.purpleMain
        view.clipsToBounds = true
        setupTableView()
        setupUICloseButton()
    }
    
    private func setupUICloseButton() {
        closeButton.imageEdgeInsets = UIEdgeInsets(top: DetailConstants.Layout.closeButtonImageInsets, left: DetailConstants.Layout.closeButtonImageInsets, bottom: DetailConstants.Layout.closeButtonImageInsets, right: DetailConstants.Layout.closeButtonImageInsets)
        closeButton.frame = CGRect(x: view.frame.width - DetailConstants.Layout.closeButtonX, y: DetailConstants.Layout.closeButtonY, width: DetailConstants.Layout.closeButtonWidthHeight, height: DetailConstants.Layout.closeButtonWidthHeight)
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        view.addSubview(closeButton)
    }
    
    @objc private func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
        dismiss(animated: true, completion: nil)
    }
}
//MARK: - TableView
private extension DetailMovieViewController {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Colors.purpleMain
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(DetailViewCell.self)
        tableView.register(DetailViewDescriptionCell.self)
    }
}

extension DetailMovieViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return DetailConstants.Layout.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == .zero {
            let headerCell = tableView.dequeueCell(cellType: DetailViewCell.self, for: indexPath)
            guard let viewModel = viewModel else { return UITableViewCell() }
            headerCell.backgroundView = nil
            headerCell.update(with: viewModel)
            return headerCell
        } else {
            let cell = tableView.dequeueCell(cellType: DetailViewDescriptionCell.self, for: indexPath)
            guard let viewModel = viewModel else { return UITableViewCell() }
            cell.update(with: viewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == .zero {
            return CGFloat(GlobalConstants.collectionCellHeight)
        }
        let font = Font.okko(ofSize: Font.Size.twenty, weight: .regular)
        guard let viewModel = viewModel else { return 0 }
        let text = viewModel.info
        let size = UILabel.textSize(font: font, text: text, width: CGFloat(GlobalConstants.collectionCellWidth))
        return size.height + 10
    }
}
