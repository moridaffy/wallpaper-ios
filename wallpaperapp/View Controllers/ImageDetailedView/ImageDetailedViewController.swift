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
  private weak var tapGestureRecognizer: UITapGestureRecognizer!
  
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
  
  @objc private func imageTapped() {
    showElements()
  }
  
  @objc private func closeButtonTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func saveButtonTapped() {
    guard let image = model.image.image else { return }
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(savingCompleted(image:error:contextInfo:)), nil)
  }
  
  @objc private func savingCompleted(image: UIImage?, error: Error?, contextInfo: UnsafeMutableRawPointer?) {
    // TODO: create some kind of toast alert
    print("🔥 successfully saved image")
  }
  
  private func setupUI() {
    let closeButton = UIBarButtonItem(title: NSLocalizedString("Close", comment: ""), style: .plain, target: self, action: #selector(closeButtonTapped))
    navigationItem.leftBarButtonItem = closeButton
    let saveButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .done, target: self, action: #selector(saveButtonTapped))
    navigationItem.rightBarButtonItem = saveButton
    
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = UIColor.red
    imageView.isUserInteractionEnabled = true
    view.addSubview(imageView)
    self.imageView = imageView
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    tapGestureRecognizer.numberOfTapsRequired = 1
    tapGestureRecognizer.numberOfTouchesRequired = 1
    self.imageView.addGestureRecognizer(tapGestureRecognizer)
    self.tapGestureRecognizer = tapGestureRecognizer
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
  
  private func showElements() {
    model.elementsHidden = !model.elementsHidden
    navigationController?.setNavigationBarHidden(model.elementsHidden, animated: true)
  }
  
}
