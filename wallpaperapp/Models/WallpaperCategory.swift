//
//  WallpaperCategory.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 13/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

class WallpaperCategory {
  
  let type: CategoryType
  
  init(type: CategoryType) {
    self.type = type
  }
  
}

extension WallpaperCategory {
  enum CategoryType: String {
    case car = "car"
    case city = "city"
    case animal = "animal"
    case nature = "nature"
    
    var image: UIImage {
      switch self {
      case .car:
        return #imageLiteral(resourceName: "category_car")
      case .city:
        return #imageLiteral(resourceName: "category_city")
      case .animal:
        return #imageLiteral(resourceName: "category_animal")
      case .nature:
        return #imageLiteral(resourceName: "category_nature")
      }
    }
    
    var name: String {
      switch self {
      case .car:
        return NSLocalizedString("Cars", comment: "")
      case .city:
        return NSLocalizedString("Cities", comment: "")
      case .animal:
        return NSLocalizedString("Animals", comment: "")
      case .nature:
        return NSLocalizedString("Nature", comment: "")
      }
    }
  }
}
