//
//  HomeCoordinator.swift
//  My Spotify
//
//  Created by Shubham Bhatt on 04/07/23.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = HomeVC.instantiate(from: .home)
        vc.homeCoordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func gotoViewSongs(songData: LibraryDisplay) {
        let viewPlaylistCoordinator = ViewPlaylistCoordinator(navigationController: navigationController, songData: songData)
        viewPlaylistCoordinator.start()
    }
    
    func goToProfile() {
        let profileCoordinator = UserProfileCoordinator(navigationController: navigationController)
        profileCoordinator.start()
    }
}
