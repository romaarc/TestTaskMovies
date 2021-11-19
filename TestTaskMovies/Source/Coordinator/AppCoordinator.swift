//
//  AppCoordinator.swift
//  TestTaskMovies
//
//  Created by Roman Gorshkov on 09.11.2021.
//

import UIKit

class AppCoordinator {
    
    private let window: UIWindow
    private lazy var tabBarController = UITabBarController()
    private lazy var navigationControllers = AppCoordinator.makeNavigationControllers()
    private lazy var networkService = NetworkService()
    private lazy var persistentProvider = PersistentProvider()
    
    init(window: UIWindow) {
        self.window = window
        navigationControllers = AppCoordinator.makeNavigationControllers()
    }
    
    func start() {
        //Kingfisher method for clear cache images
        UIImageView().setupCache()
        
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
        setupMovie()
        setupFavorites()
        let navigationControllers = NavigationControllersType.allCases.compactMap {
            self.navigationControllers[$0]
        }
        tabBarController.setViewControllers(navigationControllers, animated: true)
        setupAppearanceTabBar(with: tabBarController)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

private extension AppCoordinator {
    static func makeNavigationControllers() -> [NavigationControllersType: UINavigationController] {
        var result: [NavigationControllersType: UINavigationController] = [:]
        NavigationControllersType.allCases.forEach { navigationControllerKey in
            let navigationController = UINavigationController()
            let tabBarItem: UITabBarItem = UITabBarItem(title: navigationControllerKey.title,
                                                        image: navigationControllerKey.image,
                                                        tag: navigationControllerKey.rawValue)
            navigationController.tabBarItem = tabBarItem
            navigationController.navigationBar.prefersLargeTitles = true
            result[navigationControllerKey] = navigationController
        }
        return result
    }
    
    func setupMovie() {
        guard let navController = self.navigationControllers[.movies] else {
            fatalError("something wrong with appCoordinator")
        }
        let movieVC = MovieViewController(moviesNetworkService: networkService, persistentProvider: persistentProvider)
        movieVC.navigationItem.title = Localize.movies
        navController.setViewControllers([movieVC], animated: false)
        setupAppearanceNavigationBar(with: navController)
    }
    
    func setupFavorites() {
        guard let navController = self.navigationControllers[.favorites] else {
            fatalError("something wrong with appCoordinator")
        }
        let favoriteVC = FavoriteViewController(moviesNetworkService: networkService, persistentProvider: persistentProvider)
        navController.setViewControllers([favoriteVC], animated: false)
        favoriteVC.navigationItem.title = Localize.favorites
        setupAppearanceNavigationBar(with: navController)
    }
    
    func setupAppearanceTabBar(with controller: UITabBarController) {
        let tabBarAppearance = UITabBarAppearance()
        
        tabBarAppearance.backgroundColor = Colors.purpleMain
        
        if #available(iOS 15.0, *) {
            controller.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        controller.tabBar.standardAppearance = tabBarAppearance
        controller.tabBar.backgroundColor = Colors.purpleMain
        
        UITabBar.appearance().barTintColor = Colors.purpleMain
        UITabBar.appearance().tintColor = .white
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: controller.tabBar.frame.width, y: 0))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = Colors.lightWhite.cgColor
        shapeLayer.lineWidth = 0.2
        
        controller.tabBar.layer.addSublayer(shapeLayer)
    }
    
    func setupAppearanceNavigationBar(with controller: UINavigationController) {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = Colors.purpleMain
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                       .font : Font.okko(ofSize: Font.Size.twenty, weight: .bold)]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white,
                                                            .font : Font.okko(ofSize: Font.Size.twentyEight, weight: .bold)]
        controller.navigationBar.standardAppearance = navigationBarAppearance
        controller.navigationBar.compactAppearance = navigationBarAppearance
        controller.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
}

fileprivate enum NavigationControllersType: Int, CaseIterable {
    case movies, favorites
    var title: String {
        switch self {
        case .movies:
            return Localize.movies
        case .favorites:
            return Localize.favorites
        }
    }
    
    var image: UIImage {
        switch self {
        case .movies:
            return Localize.Images.moviesIcon
        case .favorites:
            return Localize.Images.favoritesIcon
        }
    }
}
