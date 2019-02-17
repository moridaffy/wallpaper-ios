//
//  CategoriesViewController.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 13/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
  
  private weak var collectionView: UICollectionView!
  
  private let model = CategoriesViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupCollectionView()
    setupConstraints()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    collectionView.reloadData()
  }
  
  private func setupUI() {
    let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: CategoriesCollectionViewLayout())
    collectionView.backgroundColor = UIColor.white
    view.addSubview(collectionView)
    self.collectionView = collectionView
  }
  
  private func setupCollectionView() {
    collectionView.register(CategoryCollectionCellView.self, forCellWithReuseIdentifier: "CategoryCollectionCell")
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  private func setupConstraints() {
    collectionView.snp.makeConstraints { (make) in
      make.center.size.equalTo(view)
    }
  }
}

extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model.categories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as? CategoryCollectionCellView {
      cell.setup(model: CategoryCollectionCellViewModel(category: model.categories[indexPath.row]))
      return cell
    } else {
      fatalError("🔥 Can't dequeue cell with ID: CategoryCollectionCell")
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) is CategoryCollectionCellView {
      let imageListViewController = ImageListViewController()
      let category = model.categories[indexPath.row]
      imageListViewController.setup(title: category.type.name, model: ImageListViewModel(category: model.categories[indexPath.row]))
      navigationController?.pushViewController(imageListViewController, animated: true)
    }
  }
  
}
