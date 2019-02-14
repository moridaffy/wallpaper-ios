//
//  ImageDetailedViewController.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 14/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import SnapKit

class ImageDetailedViewController: UIViewController {
  
  private weak var imageView: UIImageView!
  
  private var model: ImageDetailedViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupConstraints()
    setupContent()
  }
  
  func setup(model: ImageDetailedViewModel) {
    self.model = model
  }
  
  @objc private func closeButtonTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func saveButtonTapped() {
    guard let image = model.image.image else { return }
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
  }
  
  private func setupUI() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.barTintColor = .clear
    
    let closeButton = UIBarButtonItem(title: NSLocalizedString("Close", comment: ""), style: .plain, target: self, action: #selector(closeButtonTapped))
    navigationItem.leftBarButtonItem = closeButton
    let saveButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .done, target: self, action: #selector(saveButtonTapped))
    navigationItem.rightBarButtonItem = saveButton
    
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = UIColor.red
    view.addSubview(imageView)
    self.imageView = imageView
  }
  
  private func setupConstraints() {
    imageView.snp.makeConstraints { (make) in
      make.leading.trailing.top.bottom.equalTo(view)
    }
  }
  
  private func setupContent() {
    imageView.kf.setImage(with: URL(string: model.image.fullUrl)) { [weak self] result in
      if let image = result.value?.image {
        self?.model.image.image = image
      }
    }
  }
  
}
