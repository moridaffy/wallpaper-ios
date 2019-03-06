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
    featuredViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Featured", comment: ""), image: nil, tag: 1)
    
    let categoriesViewController = CategoriesViewController().embedInNavigationController()
    categoriesViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Categories", comment: ""), image: nil, tag: 2)
    
    let settingsViewController = SettingsViewController().embedInNavigationController()
    settingsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Settings", comment: ""), image: nil, tag: 3)
    
    viewControllers = [featuredViewController, categoriesViewController, settingsViewController]
  }
  
  private func setupTabBar() {
    tabBar.isOpaque = false
  }
  
  private func bindData() {
    SettingsManager.shared.themeMode.asObservable()
      .subscribe { [weak self] (event) in
        if let themeMode = event.element {
          switch themeMode ?? .normal {
          case .normal:
            self?.tabBar.barTintColor = UIColor.white
          case .dark:
            self?.tabBar.barTintColor = UIColor.black
          }
        }
      }.disposed(by: disposeBag)
  }
    
}
