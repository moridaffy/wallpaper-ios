//
//  ImageListViewModel.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 13/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import RxSwift

class ImageListViewModel {
  
  let images = Variable([] as [WallpaperImage])
  let category: WallpaperCategory?
  var page: Int = 1
  
  init(category: WallpaperCategory? = nil) {
    self.category = category
  }
  
  func setupContent(response: SearchCodable, append: Bool) {
    var images: [WallpaperImage] = []
    for hit in response.hits {
      images.append(WallpaperImage(fullUrl: hit.largeImageURL,
                                   previewUrl: hit.webformatURL,
                                   pageUrl: hit.pageURL,
                                   user: hit.user,
                                   likes: hit.favorites + hit.likes,
                                   views: hit.views))
    }
    if append {
      self.images.value.append(contentsOf: images)
    } else {
      self.images.value = images
    }
  }
}
