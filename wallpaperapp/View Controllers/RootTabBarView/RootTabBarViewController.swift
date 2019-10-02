//
//  RootTabBarViewController.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 13/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import RxSwift

class RootTabBarViewController: UITabBarController {
  
  private let disposeBag = DisposeBag()
  private let model = RootTabBarViewModel()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViewControllers()
    setupTabBar()
    bindData()
  }
  
  private func setupViewControllers() {
    let imageListController = ImageListViewController()
    imageListController.setup(title: NSLocalizedString("Featured", comment: ""))
    let featuredViewController = imageListController.embedInNavigationController()
    featuredViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Featured", comment: ""), image: #imageLiteral(resourceName: "icon_star"), tag: 1)
    
    let categoriesViewController = CategoriesViewController().embedInNavigationController()
    categoriesViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Categories", comment: ""), image: #imageLiteral(resourceName: "icon_categories"), tag: 2)
    
    let settingsViewController = SettingsViewController().embedInNavigationController()
    settingsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Settings", comment: ""), image: #imageLiteral(resourceName: "icon_settings"), tag: 3)
    
    viewControllers = [featuredViewController, categoriesViewController, settingsViewController]
  }
  
  private func setupTabBar() {
    tabBar.isOpaque = false
  }
  
  private func bindData() {
    SettingsManager.shared.themeMode.asObservable()
      .subscribe { [tabBar] event in
        if let themeMode = event.element {
          switch themeMode ?? .normal {
          case .normal:
            tabBar.barTintColor = .white
          case .dark:
            tabBar.barTintColor = .black
          }
        }
      }.disposed(by: disposeBag)
  }
    
}
