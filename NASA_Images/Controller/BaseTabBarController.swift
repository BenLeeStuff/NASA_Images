//
//  BaseTabBarController.swift
//  NASA_Images
//
//  Created by Ben Lee on 7/9/23.
//

import UIKit

class BaseTabBarController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(white: 0.2, alpha: 1)
        
        viewControllers = [
            createNavController(viewController: ImageSearchController(), title: "Search", imageName: "magnifyingglass"),
            createNavController(viewController: UIViewController(), title: "Home", imageName: "house")
        ]
    }
    
    func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: imageName)
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }

}
