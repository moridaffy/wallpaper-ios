//
//  RootTabBarViewController.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 13/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

class RootTabBarViewController: UITabBarController {
  
  private let model = RootTabBarViewModel()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViewControllers()
  }
  
  private func setupViewControllers() {
    let imageListController = ImageListViewController()
    imageListController.setup()
    let featuredViewController = imageListController.embedInNavigationController()
    featuredViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Featured", comment: ""), image: nil, tag: 1)
    
    let categoriesViewController = CategoriesViewController().embedInNavigationController()
    categoriesViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Categories", comment: ""), image: nil, tag: 2)
    
    let settingsViewController = SettingsViewController().embedInNavigationController()
    settingsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Settings", comment: ""), image: nil, tag: 3)
    
    viewControllers = [featuredViewController, categoriesViewController, settingsViewController]
  }
    
}
