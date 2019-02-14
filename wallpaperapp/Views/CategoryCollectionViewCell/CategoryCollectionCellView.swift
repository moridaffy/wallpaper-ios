//
//  CategoryCollectionCellView.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 13/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import SnapKit

class CategoryCollectionCellView: UICollectionViewCell {
  
  private weak var shadowView: UIView!
  private weak var categoryImageView: UIImageView!
  private weak var nameLabel: UILabel!
  
  private var model: CategoryCollectionCellViewModel!
  
  func setup(model: CategoryCollectionCellViewModel) {
    self.model = model
    
    setupUI()
    setupConstraints()
    setupContent()
  }
  
  private func setupUI() {
    let shadowView = UIView()
    shadowView.layer.masksToBounds = false
    shadowView.layer.shadowColor = UIColor.black.cgColor
    shadowView.layer.shadowOffset = CGSize.zero
    shadowView.layer.shadowOpacity = 0.25
    shadowView.layer.shadowRadius = 10.0
    addSubview(shadowView)
    self.shadowView = shadowView
    
    let categoryImageView = UIImageView()
    categoryImageView.backgroundColor = UIColor.clear
    categoryImageView.layer.cornerRadius = 16.0
    categoryImageView.layer.masksToBounds = true
    shadowView.addSubview(categoryImageView)
    self.categoryImageView = categoryImageView
    
    let nameLabel = UILabel()
    nameLabel.textColor = UIColor.white
    nameLabel.font = UIFont.systemFont(ofSize: 22.0, weight: .medium)
    nameLabel.numberOfLines = 1
    nameLabel.textAlignment = .left
    shadowView.addSubview(nameLabel)
    self.nameLabel = nameLabel
  }
  
  private func setupConstraints() {
    shadowView.snp.makeConstraints { (make) in
      make.center.equalTo(self)
      make.leading.top.equalTo(self).offset(12.0)
      make.bottom.trailing.equalTo(self).offset(-12.0)
    }
    
    categoryImageView.snp.makeConstraints { (make) in
      make.center.size.equalTo(shadowView)
    }
    
    nameLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(shadowView).offset(8.0)
      make.bottom.trailing.equalTo(shadowView).offset(-8.0)
      make.height.equalTo(20.0)
    }
  }
  
  private func setupContent() {
    categoryImageView.image = model.category.type.image
    nameLabel.text = model.category.type.name
  }
}
