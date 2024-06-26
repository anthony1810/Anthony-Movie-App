//
//  AppCoordinator.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 17/03/2022.
//

import UIKit
import XCoordinator
import Resolver
import RxSwift

indirect enum AppRoute: Route {
    case home
    case detail(movie: MovieDataType)
    case archive
    case deeplink(route: AppRoute)
    case backToRoot
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    // MARK: Initialization
    var strongMainRouter: StrongRouter<AppRoute>!
    
    init() {
        super.init(initialRoute: .home)
    }
    
    // MARK: Overrides
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .home:
            let viewController = R.storyboard.main.homeViewController()!
            viewController.bind(to: HomeViewModel(router: unownedRouter))
            return .push(viewController)
        case .detail(let movie):
            let movieDetailViewController = R.storyboard.main.movieDetailViewController()!
            movieDetailViewController.bind(to: MovieDetailViewModel(router: unownedRouter, movie: movie))
            return .push(movieDetailViewController)
        case .archive:
            let archiveVC = R.storyboard.main.archiveViewController()!
            archiveVC.bind(to: ArchiveViewModel(router: unownedRouter))
            return .push(archiveVC)
        case .deeplink(let route):
            switch route {
            case .home:
                return .popToRoot()
            case .archive:
                return deepLink(AppRoute.backToRoot, AppRoute.archive)
            case .detail(let movie):
                return deepLink(AppRoute.backToRoot, AppRoute.detail(movie: movie))
            case .backToRoot:
                return .popToRoot()
            default: return .popToRoot()
            }
        case .backToRoot: return .popToRoot()
        }
    }
    
}
