//
//  ViewController.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 05.11.2021.
//

import UIKit

class MovieViewController: UIViewController {
    
    private let collectionView: UICollectionView
    private let refreshControl = UIRefreshControl()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.hidesWhenStopped = true
        activity.color = Colors.lightWhite
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    private let moviesNetworkService: MovieNetworkProtocol
    private let persistentProvider: PersistentProviderProtocol
    
    private var isNextPageLoading: Bool = false
    private var isReloading: Bool = false
    private var hasNextPage: Bool = true
    private var page: Int = 1
    
    private var detailMovieVC: DetailMovieViewController!
    private var startingFrame: CGRect?
    private var anchoredConstraints: AnchoredConstraints?
    private var isFirstLunch: Bool = true
    
    var movies = [Movie]()
    var viewModels = [MovieCardViewModel]()
    var favoriteViewModels = [Int : MovieCardFavoriteViewModel]()
    
    init(moviesNetworkService: MovieNetworkProtocol, persistentProvider: PersistentProviderProtocol) {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        self.moviesNetworkService = moviesNetworkService
        self.persistentProvider = persistentProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Life cycles
    override func loadView() {
        let view = UIView()
        view.addSubview(collectionView)
        setupCollectionView()
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isReloading = true
        presetUpUI()
        makeViewModels()
    }
    
    private func presetUpUI() {
        view.backgroundColor = Colors.purpleMain
        navigationItem.title = Localize.movies
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.frame
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
//MARK: - Extensions CollectionsView
private extension MovieViewController {
    func setupCollectionView() {
        refreshControl.addTarget(self, action: #selector(updatePullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .lightGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = Colors.purpleMain
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.refreshControl = refreshControl
        collectionView.addSubview(refreshControl)
        collectionView.register(MovieViewCell.self)
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }

    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension MovieViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: GlobalConstants.collectionCellWidth, height: GlobalConstants.collectionCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDetailVCFullscreen(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isReloading, !isNextPageLoading, indexPath.row == (viewModels.count - 1) {
            isNextPageLoading = true
            makeViewModels()
        } else {
            return
        }
    }
}
//MARK: - UICollectionViewDataSource
extension MovieViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(cellType: MovieViewCell.self, for: indexPath)
        let viewModel = viewModels[indexPath.row]
        cell.update(with: viewModel, withRow: indexPath, with: favoriteViewModels)
        cell.delegate = self
        cell.starButtonTapDelegate = { [weak self] in
            self?.didPressStarButtonClosure()
        }
        return cell
    }
}

//MARK: - MovieCardViewDelegate
extension MovieViewController: MovieViewCellDelegate {
    func didPressStarButton(withRow indexPath: IndexPath, and favModel: MovieCardFavoriteViewModel?) {
        if let model = favModel {
            let cell = collectionView.cellForItem(at: indexPath) as! MovieViewCell
            persistentProvider.update(with: model, withAction: .update) { result in
                switch result {
                case .success(.update):
                    cell.favoriteModel = nil
                case .failure(let error):
                    print("CD: happens error when deleting: \(error.localizedDescription)")
                default:
                    break
                }
            }
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! MovieViewCell
            let favoriteViewModel = MovieCardFavoriteViewModel(id: viewModels[indexPath.row].id, isFavorite: true)
            favoriteViewModels[favoriteViewModel.id] = favoriteViewModel
            persistentProvider.update(with: favoriteViewModel, withAction: .add) { result in
                switch result {
                case .success(.add):
                    cell.favoriteModel = favoriteViewModel
                case .failure(let error):
                    print("CD: happens error: \(error.localizedDescription)")
                default:
                    break
                }
            }
        }
    }
    
    private func didPressStarButtonClosure() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
//MARK: - Extension Network Service
private extension MovieViewController {
    
    private func makeViewModels() {
        startActivityIndicator()
        let parametrsURL = MovieURLParametrs(page: page)
        moviesNetworkService.requestMovies(with: parametrsURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.didLoad(with: response.data, loadType: self.page == 1 ? .reload : .nextPage)
                self.page += 1
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func didLoad(with response: [Movie], loadType: LoadingDataType) {
        let parametersURL = MovieDetailURLParameters()
        let group = DispatchGroup()
        var dictResponse = [Int : MovieDetailResponse]()
        
        switch loadType {
        case .reload:
            isReloading = false
            movies = response
        case .nextPage:
            isNextPageLoading = false
            hasNextPage = viewModels.count > 0
            movies.append(contentsOf: response)
        }
        
        for i in 0...response.count - 1 {
            group.enter()
            moviesNetworkService.requestMoviesDetail(with: parametersURL, withId: response[i].id ?? 0) { result in
                defer { group.leave() }
                switch result {
                case .success(let detailResponse):
                    dictResponse[response[i].id ?? 0] = detailResponse
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            
            switch loadType {
            case .nextPage:
                var newViewModels = [MovieCardViewModel]()
                
                newViewModels = response.map { movie in
                
                    MovieCardViewModel(rating: String(GlobalConstants.raitingSlogan + String(movie.rate!)).uppercased(),
                                       image: movie.posterImage ?? "",
                                       info: movie.overview ?? "",
                                       date: movie.year ?? "",
                                       id: movie.id ?? 0,
                                       genre: dictResponse[movie.id ?? 0]?.genres ?? [Genres](),
                                       productionCountry: dictResponse[movie.id ?? 0]?.productionCountries?.count ?? 0 > 0 ? dictResponse[movie.id ?? 0]?.productionCountries?[0].name ?? "" : "",
                                       tagline: dictResponse[movie.id ?? 0]?.tagline ?? "")
                }
                self.viewModels.append(contentsOf: newViewModels)
            case .reload:
                self.viewModels = response.map { movie in
                    
                    MovieCardViewModel(rating: String(GlobalConstants.raitingSlogan + String(movie.rate!)).uppercased(),
                                       image: movie.posterImage ?? "",
                                       info: movie.overview ?? "",
                                       date: movie.year ?? "",
                                       id: movie.id ?? 0,
                                       genre: dictResponse[movie.id ?? 0]?.genres ?? [Genres](),
                                       productionCountry: dictResponse[movie.id ?? 0]?.productionCountries?.count ?? 0 > 0 ? dictResponse[movie.id ?? 0]?.productionCountries?[0].name ?? "" : "",
                                       tagline: dictResponse[movie.id ?? 0]?.tagline ?? "")
                }
            }
            let savedFavoriteModels = self.persistentProvider.requestModels()
            var cdFavoriteViewModels = [MovieCardFavoriteViewModel]()
            cdFavoriteViewModels = savedFavoriteModels.map { value in
                MovieCardFavoriteViewModel(id: Int(value.id), isFavorite: value.isFavorite)
            }
            cdFavoriteViewModels.forEach { value in
                self.favoriteViewModels[Int(value.id)] = value
                self.favoriteViewModels[Int(value.id)]?.isFavorite = value.isFavorite
            }
            self.stopActivityIndicator()
            self.collectionView.reloadData()
        }
    }
}

//MARK: - Extensions Refresh Control
private extension MovieViewController {
    @objc func updatePullToRefresh() {
        isReloading = true
        isNextPageLoading = false
        page = 1
        movies.removeAll()
        viewModels.removeAll()
        makeViewModels()
        refreshControl.endRefreshing()
        collectionView.reloadData()
    }
}

//MARK: - Animations to Detail
extension MovieViewController: UIGestureRecognizerDelegate {
    
    func showDetailVCFullscreen(indexPath: IndexPath) {
        setupDetailVC(with: indexPath)
        setupDetailVCStartingPosition(with: indexPath)
        beginAnimationDetailVC(with: indexPath)
    }
    
    func setupDetailVC(with indexPath: IndexPath) {
        let detailMovieVC = DetailMovieViewController()
        detailMovieVC.viewModel = viewModels[indexPath.row]
        
        detailMovieVC.dismissHandler = { [weak self] in
            self?.handleDetailMovieVCDismissal(with: indexPath)
        }
        
        detailMovieVC.view.layer.cornerRadius = 15
        self.detailMovieVC = detailMovieVC
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        detailMovieVC.view.addGestureRecognizer(gesture)
    }
    
    func setupDetailVCStartingPosition(with indexPath: IndexPath) {
        let fullscreenView = detailMovieVC.view!
        view.addSubview(fullscreenView)
        addChild(detailMovieVC)
        self.collectionView.isUserInteractionEnabled = false
        setupStartingCellFrame(indexPath)
        guard let startingFrame = self.startingFrame else { return }
        
        self.anchoredConstraints = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: .zero, right: 20), size: CGSize(width: startingFrame.width, height: startingFrame.height)) 
        self.view.layoutIfNeeded()
    }
    
    func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
    }
    
    func beginAnimationDetailVC(with indexPath: IndexPath) {
        UIView.animate(withDuration: 1, delay: .zero, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.anchoredConstraints?.top?.constant = .zero
            self.anchoredConstraints?.leading?.constant = .zero
            self.anchoredConstraints?.width?.constant = self.view.bounds.width
            self.anchoredConstraints?.height?.constant = self.view.bounds.height
            
            self.view.layoutIfNeeded() // starts animation
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
            var frameTabBar = self.navigationController?.tabBarController?.tabBar.frame
            let frameTabBarHeight = (frameTabBar?.size.height)!
            frameTabBar?.origin.y = self.view.frame.size.height + frameTabBarHeight
            self.navigationController?.tabBarController?.tabBar.frame = frameTabBar!
            
        }, completion: nil)
    }
    
    func handleDetailMovieVCDismissal(with indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.7, delay: .zero, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.detailMovieVC.view.transform = .identity
            self.detailMovieVC.tableView.contentOffset = .zero
            
            guard let startingFrame = self.startingFrame else { return }
            self.anchoredConstraints?.top?.constant = startingFrame.origin.y
            self.anchoredConstraints?.leading?.constant = startingFrame.origin.x
            self.anchoredConstraints?.width?.constant = startingFrame.width
            self.anchoredConstraints?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            var frameTabBar = self.navigationController?.tabBarController?.tabBar.frame
            let frameTabBarHeight = (frameTabBar?.size.height)!
            frameTabBar?.origin.y = self.view.frame.size.height - frameTabBarHeight
            self.navigationController?.tabBarController?.tabBar.frame = frameTabBar!
            
            self.detailMovieVC.closeButton.alpha = .zero
            
        }, completion: { _ in
            self.detailMovieVC.view.removeFromSuperview()
            self.children.forEach {
                $0.willMove(toParent: nil)
                $0.view.removeFromSuperview()
                $0.removeFromParent()
            }
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    @objc private func handleDrag(gesture: UIPanGestureRecognizer) {
        var detailMovieVCBeginOffset: CGFloat = .zero
        if gesture.state == .began {
            detailMovieVCBeginOffset = detailMovieVC.tableView.contentOffset.y
        }
        
        if detailMovieVC.tableView.contentOffset.y > .zero {
            return
        }
        
        let translationY = gesture.translation(in: detailMovieVC.view).y
        
        if gesture.state == .changed {
            if translationY > .zero {
                let trueOffset = translationY - detailMovieVCBeginOffset
                
                var scale = 1 - trueOffset / 1000
                
                scale = min(1, scale)
                scale = max(0.5, scale)
                
                let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
                self.detailMovieVC.view.transform = transform
            }
            
        } else if gesture.state == .ended {
            if translationY > .zero {
                handleDetailMovieVCDismissal(with: IndexPath(row: 1, section: 1))
            }
        }
    }
}
