//
//  ThemedNavigationController.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 26/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import RxSwift

class ThemedNavigationController: UINavigationController {
  
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    bindData()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    switch SettingsManager.shared.themeMode.value ?? .normal {
    case .normal:
      return .default
    case .dark:
      return .lightContent
    }
  }
  
  private func setupNavigationBar() {
    navigationBar.isOpaque = false
  }
  
  private func bindData() {
    SettingsManager.shared.themeMode.asObservable()
      .subscribe { [weak self] (event) in
        if let themeMode = event.element {
          switch themeMode ?? .normal {
          case .normal:
            self?.navigationBar.barTintColor = UIColor.white
            self?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
          case .dark:
            self?.navigationBar.barTintColor = UIColor.black
            self?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
          }
        }
        self?.setNeedsStatusBarAppearanceUpdate()
      }.disposed(by: disposeBag)
  }
  
}
