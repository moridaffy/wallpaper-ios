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
    case food = "food"
    case fashion = "fashion"
    case abstract = "abstract"
    case music = "music"
    case sport = "sport"
    
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
      case .food:
        return #imageLiteral(resourceName: "category_food")
      case .fashion:
        return #imageLiteral(resourceName: "category_fashion")
      case .abstract:
        return #imageLiteral(resourceName: "category_abstract")
      case .music:
        return #imageLiteral(resourceName: "category_music")
      case .sport:
        return #imageLiteral(resourceName: "category_sport")
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
      case .food:
        return NSLocalizedString("Food", comment: "")
      case .fashion:
        return NSLocalizedString("Fashion", comment: "")
      case .abstract:
        return NSLocalizedString("Abstract", comment: "")
      case .music:
        return NSLocalizedString("Music", comment: "")
      case .sport:
        return NSLocalizedString("Sport", comment: "")
      }
    }
  }
}
