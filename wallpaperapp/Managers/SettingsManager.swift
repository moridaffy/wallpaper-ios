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
    case cropModeValue = "ru.mskr.wallpaperapp.cropModeValue"
  }
  
  var blurMode: BlurMode {
    get {
      return BlurMode(rawValue: UserDefaults.standard.value(forKey: Keys.blurModeValue.rawValue) as? String ?? "") ?? .gaussian
    }
    set {
      UserDefaults.standard.set(newValue.rawValue, forKey: Keys.blurModeValue.rawValue)
    }
  }
  
  var cropMode: CropMode {
    get {
      return CropMode(rawValue: UserDefaults.standard.value(forKey: Keys.cropModeValue.rawValue) as? Int ?? 0) ?? .dontCrop
    }
    set {
      UserDefaults.standard.set(newValue.rawValue, forKey: Keys.cropModeValue.rawValue)
    }
  }
}

extension SettingsManager {
  enum BlurMode: String {
    case gaussian = "CIGaussianBlur"
    case disk = "CIDiskBlur"
    case box = "CIBoxBlur"
    case motion = "CIMotionBlur"
  }
  
  enum CropMode: Int {
    case crop = 1
    case dontCrop = 2
  }
}
