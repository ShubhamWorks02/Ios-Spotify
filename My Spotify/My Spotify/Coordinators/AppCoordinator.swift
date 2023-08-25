//
//  File.swift
//  My Spotify
//
//  Created by Shubham Bhatt on 04/07/23.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    var window: UIWindow
    
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }
    
    func start() {
        KeychainHelper.shared.accessToken == nil ? goToAuth() : goToCombineScreen()
    }
    
    func goToCombineScreen() {
        let combineCoordinator = CombineCoordinator(navigationController: navigationController)
        self.window.rootViewController = navigationController
        combineCoordinator.start()
    }
    
    func goToAuth(with code: String? = nil) {
        let authCoordinator = AuthCoordinator(navigationController: navigationController, with: code)
        self.window.rootViewController = navigationController
        authCoordinator.start()
    }
}
