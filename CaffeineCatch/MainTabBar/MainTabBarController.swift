//
//  MainTabBarController.swift
//  CaffeineCatch
//
//  Created by 한소희 on 9/24/24.
//

import Foundation
import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainTabBar()
        setupMainTabBar()
    }
    
    private func configureMainTabBar() {
        tabBar.layer.masksToBounds = false
        tabBar.tintColor = .label
        tabBar.backgroundColor = .systemBackground
        tabBar.layer.cornerRadius = 24.0
    }
    
    private func setupMainTabBar() {
        let myGoalTab = UINavigationController(rootViewController: MyGoalViewController())
        myGoalTab.tabBarItem = UITabBarItem(title: "Goal", image: UIImage(systemName: "person.circle"), tag: 0)
        viewControllers = [myGoalTab]
        tabBarController?.setViewControllers(viewControllers, animated: true)
    }
}
