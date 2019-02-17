//
//  ImageTableViewCellView.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 13/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import SnapKit
import Kingfisher

class ImageTableCellView: UITableViewCell {
  
  private weak var photoImageView: UIImageView!
  private weak var infoView: UIView!
  private weak var viewsIconImageView: UIImageView!
  private weak var viewsLabel: UILabel!
  private weak var likesIconImageView: UIImageView!
  private weak var likesLabel: UILabel!
  
  private var model: ImageTableCellViewModel!
  
  override func prepareForReuse() {
    super.prepareForReuse()
    viewsIconImageView.removeFromSuperview()
    viewsLabel.removeFromSuperview()
    likesIconImageView.removeFromSuperview()
    likesLabel.removeFromSuperview()
    infoView.removeFromSuperview()
    photoImageView.removeFromSuperview()
  }
  
  func setup(model: ImageTableCellViewModel) {
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
    
    let infoView = UIView()
    infoView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    infoView.layer.cornerRadius = 10.0
    infoView.layer.masksToBounds = true
    addSubview(infoView)
    self.infoView = infoView
    
    let viewsIconImageView = UIImageView()
    viewsIconImageView.tintColor = UIColor.white
    viewsIconImageView.contentMode = .scaleAspectFit
    infoView.addSubview(viewsIconImageView)
    self.viewsIconImageView = viewsIconImageView
    
    let viewsLabel = UILabel()
    viewsLabel.textColor = UIColor.white
    viewsLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    infoView.addSubview(viewsLabel)
    self.viewsLabel = viewsLabel
    
    let likesIconImageView = UIImageView()
    likesIconImageView.tintColor = UIColor.white
    likesIconImageView.contentMode = .scaleAspectFit
    infoView.addSubview(likesIconImageView)
    self.likesIconImageView = likesIconImageView
    
    let likesLabel = UILabel()
    likesLabel.textColor = UIColor.white
    likesLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    infoView.addSubview(likesLabel)
    self.likesLabel = likesLabel
    
    selectionStyle = .none
    layer.masksToBounds = true
  }
  
  private func setupConstraints() {
    photoImageView.snp.makeConstraints { (make) in
      make.center.size.equalTo(self)
    }
    
    infoView.snp.makeConstraints { (make) in
      make.leading.equalTo(self).offset(8.0)
      make.bottom.equalTo(self).offset(-8.0)
    }
    
    viewsIconImageView.snp.makeConstraints { (make) in
      make.leading.top.equalTo(infoView).offset(8.0)
      make.width.height.equalTo(14.0)
    }

    viewsLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(viewsIconImageView.snp.trailing).offset(4.0)
      make.centerY.equalTo(viewsIconImageView)
      make.trailing.equalTo(infoView).offset(-8.0)
    }

    likesIconImageView.snp.makeConstraints { (make) in
      make.top.equalTo(viewsIconImageView.snp.bottom).offset(4.0)
      make.leading.equalTo(infoView).offset(8.0)
      make.width.height.equalTo(14.0)
      make.bottom.equalTo(infoView).offset(-8.0)
    }

    likesLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(likesIconImageView.snp.trailing).offset(4.0)
      make.centerY.equalTo(likesIconImageView)
      make.trailing.equalTo(infoView).offset(-8.0)
    }
  }
  
  private func setupContent() {
    photoImageView.kf.setImage(with: URL(string: model.image.previewUrl))
    viewsIconImageView.image = #imageLiteral(resourceName: "icon_views").withRenderingMode(.alwaysTemplate)
    viewsLabel.text = "\(model.image.views)"
    likesIconImageView.image = #imageLiteral(resourceName: "icon_likes").withRenderingMode(.alwaysTemplate)
    likesLabel.text = "\(model.image.likes)"
  }
}
