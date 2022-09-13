//
//  AppDelegate.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 08/09/2022.
//

import RxCocoa
import RxSwift
import Resolver
import XCoordinator
import Action
import DifferenceKit
import RxAppState

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var mainWindow: UIWindow = UIWindow()
    private var appCoordinator = AppCoordinator()
    
    @LazyInjected(container: .services)
    private var apiService: HomeServiceType
    
    @LazyInjected(container: .services)
    private var persistenceService: DataPersistenceServiceType

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LibsManager.shared.setupLibs(application, didFinishLaunchingWithOptions: launchOptions)
        ///
        Resolver.registerAllServices()
        ///
        mainWindow.backgroundColor = .white
        appCoordinator.strongRouter.setRoot(for: mainWindow)

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        persistenceService.saveLastVisitedTime()
    }

}

