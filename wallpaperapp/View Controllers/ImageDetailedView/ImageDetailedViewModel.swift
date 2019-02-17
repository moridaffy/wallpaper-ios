//
//  ImageDetailedViewModel.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 14/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

class ImageDetailedViewModel {
  
  let image: WallpaperImage
  var elementsHidden: Bool = false
  
  init(image: WallpaperImage) {
    self.image = image
  }
  
}
