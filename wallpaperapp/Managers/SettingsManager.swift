//
//  SettingsManager.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 22/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import RxSwift

class SettingsManager {
  
  static let shared: SettingsManager = {
    let manager = SettingsManager()
    manager.blurMode.value = BlurMode(rawValue: UserDefaults.standard.value(forKey: Keys.blurModeValue.rawValue) as? Int ?? 0) ?? .gaussian
    manager.themeMode.value = ThemeMode(rawValue: UserDefaults.standard.value(forKey: Keys.themeModeValue.rawValue) as? Int ?? 0) ?? .normal
    manager.perPage.value = UserDefaults.standard.value(forKey: Keys.perPageValue.rawValue) as? Int ?? 20
    manager.bindData()
    return manager
  }()
  
  private enum Keys: String {
    case blurModeValue = "ru.mskr.wallpaperapp.blurModeValue"
    case themeModeValue = "ru.mskr.wallpaperapp.themeModeValue"
    case perPageValue = "ru.mskr.wallpaperapp.perPageValue"
  }
  
  private let disposeBag = DisposeBag()
  
  let demoMode: Bool = true
  let perPage = Variable(20)
  let blurMode = Variable(nil as BlurMode?)
  let themeMode = Variable(nil as ThemeMode?)
  
  func bindData() {
    blurMode.asObservable()
      .skip(1)
      .subscribe(onNext: { (value) in
        UserDefaults.standard.set((value ?? .gaussian).rawValue, forKey: Keys.blurModeValue.rawValue)
      }).disposed(by: disposeBag)
    
    themeMode.asObservable()
      .skip(1)
      .subscribe(onNext: { (value) in
        UserDefaults.standard.set((value ?? .normal).rawValue, forKey: Keys.themeModeValue.rawValue)
      }).disposed(by: disposeBag)
    
    perPage.asObservable()
      .skip(1)
      .subscribe { (value) in
        UserDefaults.standard.set(value.element ?? 20, forKey: Keys.perPageValue.rawValue)
      }.disposed(by: disposeBag)
  }
}

extension SettingsManager {
  enum BlurMode: Int {
    case gaussian = 0
    case disc = 1
    case box = 2
    case motion = 3
    
    var filterName: String {
      switch self {
      case .gaussian:
        return "CIGaussianBlur"
      case .disc:
        return "CIDiscBlur"
      case .box:
        return "CIBoxBlur"
      case .motion:
        return "CIMotionBlur"
      }
    }
  }
  
  enum ThemeMode: Int {
    case normal = 0
    case dark = 1
  }
}
