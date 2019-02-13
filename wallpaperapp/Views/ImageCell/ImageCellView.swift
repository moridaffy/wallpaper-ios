//
//  ImageCellView.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 13/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import SnapKit
import Kingfisher

class ImageCellView: UITableViewCell {
  
  private weak var photoImageView: UIImageView!
  
  private var model: ImageCellViewModel!
  
  func setup(model: ImageCellViewModel) {
    self.model = model
    
    setupUI()
    setupConstraints()
    setupContent()
  }
  
  private func setupUI() {
    let photoImageView = UIImageView()
    photoImageView.contentMode = .scaleAspectFill
    addSubview(photoImageView)
    self.photoImageView = photoImageView
    
    selectionStyle = .none
    layer.masksToBounds = true
  }
  
  private func setupConstraints() {
    photoImageView.snp.makeConstraints { (make) in
      make.center.size.equalTo(self)
    }
  }
  
  private func setupContent() {
    photoImageView.kf.setImage(with: URL(string: model.imageUrl))
  }
}
