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
  private weak var iconsImageView: UIImageView!
  private weak var blurSlider: UISlider!
  private weak var iconsButton: UIButton!
  private weak var tapGestureRecognizer: UITapGestureRecognizer!
  
  private var model: ImageDetailedViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.black
    
    setupUI()
    setupConstraints()
    setupContent()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    iconsButton.layer.cornerRadius = iconsButton.frame.height / 2
    iconsButton.layer.masksToBounds = true
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
    let context = CIContext()
    if let ciImage = imageView.image?.ciImage,
       let imageToSave = context.createCGImage(ciImage, from: ciImage.extent) {

      UIImageWriteToSavedPhotosAlbum(UIImage(cgImage: imageToSave), self, #selector(savingCompleted(image:error:contextInfo:)), nil)
    }
  }
  
  @objc private func iconsButtonTapped() {
    model.iconsHidden = !model.iconsHidden
    UIView.animate(withDuration: 0.3) {
      self.iconsImageView.alpha = self.model.iconsHidden ? 0.0 : 1.0
    }
  }
  
  @objc private func blurSliderValueChanged(_ sender: Any) {
    if let slider = sender as? UISlider,
       let fullImage = model.image.image,
       let fullCIImage = CIImage(image: fullImage) {
      
      let blurFilter = CIFilter(name: (SettingsManager.shared.blurMode.value ?? .gaussian).filterName,
                                parameters: [kCIInputImageKey: fullCIImage.clampedToExtent(),
                                             kCIInputRadiusKey: slider.value * 25.0])
      if let outputCIImage = blurFilter?.outputImage?.cropped(to: fullCIImage.extent) {
        imageView.image = UIImage(ciImage: outputCIImage)
      }
    }
  }
  
  @objc private func savingCompleted(image: UIImage?, error: Error?, contextInfo: UnsafeMutableRawPointer?) {
    // TODO: create some kind of toast alert
    showAlert(title: NSLocalizedString("Done", comment: ""), body: NSLocalizedString("Image successfylly saved", comment: ""), button: "Ок", actions: nil)
  }
  
  private func setupUI() {
    let closeButton = UIBarButtonItem(title: NSLocalizedString("Close", comment: ""), style: .plain, target: self, action: #selector(closeButtonTapped))
    navigationItem.leftBarButtonItem = closeButton
    let saveButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .done, target: self, action: #selector(saveButtonTapped))
    navigationItem.rightBarButtonItem = saveButton
    
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
    view.addSubview(imageView)
    self.imageView = imageView
    
    let iconsImageView = UIImageView()
    iconsImageView.contentMode = .scaleAspectFill
    iconsImageView.isUserInteractionEnabled = false
    iconsImageView.alpha = 0.0
    view.addSubview(iconsImageView)
    self.iconsImageView = iconsImageView
    
    let blurSlider = UISlider()
    blurSlider.value = 0.0
    blurSlider.addTarget(self, action: #selector(blurSliderValueChanged(_:)), for: .touchUpInside)
    blurSlider.addTarget(self, action: #selector(blurSliderValueChanged(_:)), for: .touchUpOutside)
    view.addSubview(blurSlider)
    self.blurSlider = blurSlider
    
    let iconsButton = UIButton()
    iconsButton.backgroundColor = (SettingsManager.shared.themeMode.value == .normal) ? UIColor.white : UIColor.black
    iconsButton.tintColor = (SettingsManager.shared.themeMode.value == .normal) ? UIColor.black : UIColor.white
    iconsButton.setImage(#imageLiteral(resourceName: "icon_icons").withRenderingMode(.alwaysTemplate), for: .normal)
    iconsButton.imageEdgeInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
    iconsButton.addTarget(self, action: #selector(iconsButtonTapped), for: .touchUpInside)
    view.addSubview(iconsButton)
    self.iconsButton = iconsButton
    
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
    
    iconsImageView.snp.makeConstraints { (make) in
      make.leading.trailing.top.bottom.equalTo(view)
    }
    
    iconsButton.snp.makeConstraints { (make) in
      make.trailing.equalTo(view).offset(-16.0)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16.0)
      make.height.width.equalTo(50.0)
    }
    
    blurSlider.snp.makeConstraints { (make) in
      make.leading.equalTo(view).offset(16.0)
      make.trailing.equalTo(iconsButton.snp.leading).offset(-16.0)
      make.centerY.equalTo(iconsButton)
    }
  }
  
  private func setupContent() {
    iconsImageView.image = UIDevice.current.type.iconsImage
    imageView.kf.setImage(with: URL(string: model.image.fullUrl)) { [model] result in
      switch result {
      case .success(let value):
        model?.image.image = value.image
      case .failure(let error):
        print("Job failed: \(error.localizedDescription)")
      }
    }
  }
  
  private func hideElements(hide: Bool? = nil) {
    model.elementsHidden = hide ?? !model.elementsHidden
    setNeedsStatusBarAppearanceUpdate()
    navigationController?.setNavigationBarHidden(model.elementsHidden, animated: true)
    UIView.animate(withDuration: 0.3) {
      self.blurSlider.alpha = self.model.elementsHidden ? 0.0 : 1.0
      self.iconsButton.alpha = self.model.elementsHidden ? 0.0 : 1.0
    }
  }
  
}
