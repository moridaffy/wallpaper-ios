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
  private weak var blurSlider: UISlider!
  private weak var blurView: UIView!
  private weak var tapGestureRecognizer: UITapGestureRecognizer!
  
  private var model: ImageDetailedViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupConstraints()
    setupContent()
  }
  
  override var prefersStatusBarHidden: Bool {
    return model.elementsHidden
  }
  
  override var prefersHomeIndicatorAutoHidden: Bool {
    return model.elementsHidden
  }
  
  func setup(model: ImageDetailedViewModel) {
    self.model = model
  }
  
  @objc private func imageTapped() {
    hideElements()
  }
  
  @objc private func closeButtonTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func saveButtonTapped() {
    guard let image = model.image.image else { return }
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(savingCompleted(image:error:contextInfo:)), nil)
  }
  
  @objc private func blurSliderValueChanged(_ sender: Any) {
    // TODO: maybe try to generate blurred UIImage every time this value changes
    //       and store it as a variable. If user taps save button, stored image
    //       will be saved to photos library.
    
    if let slider = sender as? UISlider {
      blurView.blurView.intensity = CGFloat(slider.value)
    }
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
    
    let blurView = UIView()
    _ = blurView.blurView.setup(style: .light, intensity: 0.0)
    view.addSubview(blurView)
    self.blurView = blurView
    
    let blurSlider = UISlider()
    blurSlider.value = 0.0
    blurSlider.addTarget(self, action: #selector(blurSliderValueChanged(_:)), for: .valueChanged)
    view.addSubview(blurSlider)
    self.blurSlider = blurSlider
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    tapGestureRecognizer.numberOfTapsRequired = 1
    tapGestureRecognizer.numberOfTouchesRequired = 1
    self.blurView.addGestureRecognizer(tapGestureRecognizer)
    self.tapGestureRecognizer = tapGestureRecognizer
  }
  
  private func setupConstraints() {
    imageView.snp.makeConstraints { (make) in
      make.leading.trailing.top.bottom.equalTo(view)
    }
    
    blurView.snp.makeConstraints { (make) in
      make.leading.trailing.top.bottom.equalTo(view)
    }
    
    blurSlider.snp.makeConstraints { (make) in
      make.leading.equalTo(view).offset(16.0)
      make.trailing.equalTo(view).offset(-16.0)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16.0)
    }
  }
  
  private func setupContent() {
    imageView.kf.setImage(with: URL(string: model.image.fullUrl)) { [weak self] result in
      if let image = result.value?.image {
        self?.model.image.image = image
      }
    }
  }
  
  private func hideElements(hide: Bool? = nil) {
    model.elementsHidden = hide ?? !model.elementsHidden
    setNeedsStatusBarAppearanceUpdate()
    navigationController?.setNavigationBarHidden(model.elementsHidden, animated: true)
    UIView.animate(withDuration: 0.3) {
      self.blurSlider.alpha = self.model.elementsHidden ? 0.0 : 1.0
    }
  }
  
}
