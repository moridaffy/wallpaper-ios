//
//  CategoriesCollectionViewLayout.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 13/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

class CategoriesCollectionViewLayout: UICollectionViewFlowLayout {
  
  override init() {
    super.init()
    self.minimumLineSpacing = 1.0
    self.minimumInteritemSpacing = 1.0
    self.scrollDirection = .vertical
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private var side: CGFloat {
    if let collectionView = collectionView {
      return collectionView.frame.width / 2 - 2.0
    } else {
      return 44.0
    }
  }
  
  override var itemSize: CGSize {
    set {
      fatalError("🔥 Changing item size is not supported!")
    }
    get {
      return CGSize(width: side, height: side)
    }
  }
  
}
