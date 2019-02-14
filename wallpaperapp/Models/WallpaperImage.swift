//
//  WallpaperImage.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 13/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

class WallpaperImage {
  let fullUrl: String
  let previewUrl: String
  let pageUrl: String
  let user: String
  let likes: Int
  let views: Int
  
  var image: UIImage?
  
  init(fullUrl: String,
       previewUrl: String,
       pageUrl: String,
       user: String,
       likes: Int,
       views: Int) {
    
    self.fullUrl = fullUrl
    self.previewUrl = previewUrl
    self.pageUrl = pageUrl
    self.user = user
    self.likes = likes
    self.views = views
  }
}
