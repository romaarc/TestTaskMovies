//
//  FavoriteViewController.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 10.11.2021.
//

import UIKit

final class FavoriteViewController: UIViewController {

    private let persistentProvider: PersistentProviderProtocol
    private let moviesNetworkService: MovieNetworkProtocol
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var favoriteViewModels = [FavoriteViewModel]()
    private var isFirstLunch: Bool = false
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.hidesWhenStopped = true
        activity.color = Colors.lightWhite
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    init(moviesNetworkService: MovieNetworkProtocol, persistentProvider: PersistentProviderProtocol) {
        self.moviesNetworkService = moviesNetworkService
        self.persistentProvider = persistentProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupActivityIndicator()
        makeViewModels()
        isFirstLunch = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isFirstLunch {
            favoriteViewModels.removeAll()
            makeViewModels()
        }
    }
}
//MARK: - TableView
private extension FavoriteViewController {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.backgroundColor = Colors.purpleMain
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: FavoriteConstants.Layout.separatorInsetTop, left: .zero, bottom: .zero, right: .zero)
        tableView.register(FavoriteViewCell.self)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }

    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
}

extension FavoriteViewController: UITableViewDelegate {}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(cellType: FavoriteViewCell.self, for: indexPath)
        let viewModel = favoriteViewModels[indexPath.row]
        cell.update(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FavoriteConstants.Layout.heightForRowAt
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return FavoriteConstants.Layout.heightForRowAt
    }
}
//MARK: - View Models
private extension FavoriteViewController {
    func makeViewModels() {
        startActivityIndicator()
        let group = DispatchGroup()
        let parametersURL = MovieDetailURLParameters()
        var dict = [Int: MovieDetailResponse]()
        
        let coreDataModels = persistentProvider.requestModels()
        
        for model in coreDataModels {
            let id = Int(model.id)
            group.enter()
            moviesNetworkService.requestMoviesDetail(with: parametersURL, withId: id) { result in
                defer { group.leave() }
                switch result {
                case .success(let detailResponse):
                    dict[id] = detailResponse
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            self.favoriteViewModels = coreDataModels.map { model in
                FavoriteViewModel(id: Int(model.id), image: dict[Int(model.id)]?.backdropPath ?? "", title: dict[Int(model.id)]?.title ?? "", releaseDate: dict[Int(model.id)]?.releaseDate ?? "", date: model.currentDate ?? Date().getGMTTimeDate())
            }
            self.isFirstLunch = false
            self.stopActivityIndicator()
            self.tableView.reloadData()
        }
    }
}
