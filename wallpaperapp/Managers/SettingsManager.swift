//
//  SettingsManager.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 22/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import Foundation

class SettingsManager {
  
  static let shared = SettingsManager()
  
  private enum Keys: String {
    case blurModeValue = "ru.mskr.wallpaperapp.blurModeValue"
  }
  
  var blurMode: BlurMode? {
    get {
      return BlurMode(rawValue: UserDefaults.standard.value(forKey: Keys.blurModeValue.rawValue) as? Int ?? 0) ?? .gaussian
    }
    set {
      UserDefaults.standard.set((newValue ?? .gaussian).rawValue, forKey: Keys.blurModeValue.rawValue)
    }
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
}
