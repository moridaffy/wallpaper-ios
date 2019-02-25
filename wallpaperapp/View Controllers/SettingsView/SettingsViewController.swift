//
//  SettingsViewController .swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 13/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import SnapKit
import RxSwift
import Kingfisher

class SettingsViewController: UIViewController {
  
  private weak var blurModeLabel: UILabel!
  private weak var blurModeSelector: UISegmentedControl!
  private weak var cacheSizeLabel: UILabel!
  
  private let disposeBag = DisposeBag()
  private let model = SettingsViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupElements()
    setupStyle()
    setupContent()
  }
  
  private func setupElements() {
    let blurModeLabel = UILabel()
    view.addSubview(blurModeLabel)
    blurModeLabel.snp.makeConstraints { (make) in
      make.leading.top.equalTo(view.safeAreaLayoutGuide).offset(16.0)
    }
    self.blurModeLabel = blurModeLabel

    let blurModeSelector = UISegmentedControl()
    view.addSubview(blurModeSelector)
    blurModeSelector.snp.makeConstraints { (make) in
      make.width.equalTo(250.0)
      make.trailing.equalTo(view).offset(-16.0)
      make.centerY.equalTo(self.blurModeLabel)
    }
    self.blurModeSelector = blurModeSelector
    
    let cacheSizeLabel = UILabel()
    view.addSubview(cacheSizeLabel)
    cacheSizeLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(view).offset(16.0)
      make.top.equalTo(blurModeLabel.snp.bottom).offset(16.0)
      make.trailing.equalTo(view).offset(-16.0)
    }
    self.cacheSizeLabel = cacheSizeLabel
  }
  
  private func setupStyle() {
    view.backgroundColor = UIColor.white
  }
  
  private func setupContent() {
    blurModeLabel.text = NSLocalizedString("Blur mode", comment: "")
    blurModeSelector.insertSegment(withTitle: "Motion", at: 0, animated: false)
    blurModeSelector.insertSegment(withTitle: "Box", at: 0, animated: false)
    blurModeSelector.insertSegment(withTitle: "Disc", at: 0, animated: false)
    blurModeSelector.insertSegment(withTitle: "Gaussian", at: 0, animated: false)
    blurModeSelector.selectedSegmentIndex = SettingsManager.shared.blurMode?.rawValue ?? 0
    blurModeSelector.rx.value
      .skip(1)
      .subscribe(onNext: { index in
        SettingsManager.shared.blurMode = SettingsManager.BlurMode(rawValue: index)
      }).disposed(by: disposeBag)
    
    cacheSizeLabel.text = NSLocalizedString("Cache size", comment: "") + ": " + NSLocalizedString("Calculating", comment: "") + "..."
    KingfisherManager.shared.cache.calculateDiskStorageSize { [weak self] (result) in
      if let value = result.value {
        self?.cacheSizeLabel.text = NSLocalizedString("Cache size", comment: "") + ": \(value) " + NSLocalizedString("kb", comment: "")
      } else {
        self?.cacheSizeLabel.text = NSLocalizedString("Cache size", comment: "") + ": \(result.error?.localizedDescription ?? NSLocalizedString("Unknown error", comment: ""))"
      }
    }
  }
}
