//
//  File.swift
//  My Spotify
//
//  Created by Shubham Bhatt on 04/07/23.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
