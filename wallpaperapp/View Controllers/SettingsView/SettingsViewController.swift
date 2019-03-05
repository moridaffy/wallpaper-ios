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
  private weak var themeModeLabel: UILabel!
  private weak var themeModeSelector: UISegmentedControl!
  private weak var cacheSizeLabel: UILabel!
  private weak var clearCacheButton: UIButton!
  
  private let disposeBag = DisposeBag()
  private let model = SettingsViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupElements()
    setupStyle()
    setupContent()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadCacheSize()
  }
  
  private func setupElements() {
    let blurModeLabel = UILabel()
    view.addSubview(blurModeLabel)
    blurModeLabel.snp.makeConstraints { (make) in
      make.leading.top.equalTo(view.safeAreaLayoutGuide).offset(16.0)
      make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16.0)
    }
    self.blurModeLabel = blurModeLabel

    let blurModeSelector = UISegmentedControl()
    view.addSubview(blurModeSelector)
    blurModeSelector.snp.makeConstraints { (make) in
      make.leading.trailing.equalTo(blurModeLabel)
      make.top.equalTo(blurModeLabel.snp.bottom).offset(4.0)
    }
    self.blurModeSelector = blurModeSelector
    
    let themeModeLabel = UILabel()
    view.addSubview(themeModeLabel)
    themeModeLabel.snp.makeConstraints { (make) in
      make.leading.trailing.equalTo(blurModeLabel)
      make.top.equalTo(blurModeSelector.snp.bottom).offset(32.0)
    }
    self.themeModeLabel = themeModeLabel
    
    let themeModeSelector = UISegmentedControl()
    view.addSubview(themeModeSelector)
    themeModeSelector.snp.makeConstraints { (make) in
      make.leading.trailing.equalTo(blurModeLabel)
      make.top.equalTo(themeModeLabel.snp.bottom).offset(4.0)
    }
    self.themeModeSelector = themeModeSelector
    
    let cacheSizeLabel = UILabel()
    view.addSubview(cacheSizeLabel)
    cacheSizeLabel.snp.makeConstraints { (make) in
      make.leading.trailing.equalTo(blurModeLabel)
      make.top.equalTo(themeModeSelector.snp.bottom).offset(32.0)
    }
    self.cacheSizeLabel = cacheSizeLabel
    
    let clearCacheButton = UIButton(type: .custom)
    view.addSubview(clearCacheButton)
    clearCacheButton.snp.makeConstraints { (make) in
      make.leading.trailing.equalTo(blurModeLabel)
      make.height.equalTo(blurModeSelector)
      make.top.equalTo(cacheSizeLabel.snp.bottom).offset(4.0)
    }
    self.clearCacheButton = clearCacheButton
  }
  
  private func setupStyle(theme: SettingsManager.ThemeMode = SettingsManager.shared.themeMode.value ?? .normal) {
    let lightTheme = theme == .normal
    view.backgroundColor = lightTheme ? UIColor.white : UIColor.black
    blurModeLabel.textColor = lightTheme ? UIColor.black : UIColor.white
    themeModeLabel.textColor = lightTheme ? UIColor.black : UIColor.white
    cacheSizeLabel.textColor = lightTheme ? UIColor.black : UIColor.white
    clearCacheButton.layer.cornerRadius = 3.0
    clearCacheButton.layer.masksToBounds = true
    clearCacheButton.backgroundColor = view.tintColor
    clearCacheButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
    clearCacheButton.setTitleColor(lightTheme ? UIColor.white : UIColor.black, for: .normal)
  }
  
  private func setupContent() {
    title = NSLocalizedString("Settings", comment: "")
    
    blurModeLabel.text = NSLocalizedString("Blur mode", comment: "")
    blurModeSelector.insertSegment(withTitle: "Motion", at: 0, animated: false)
    blurModeSelector.insertSegment(withTitle: "Box", at: 0, animated: false)
    blurModeSelector.insertSegment(withTitle: "Disc", at: 0, animated: false)
    blurModeSelector.insertSegment(withTitle: "Gaussian", at: 0, animated: false)
    blurModeSelector.selectedSegmentIndex = SettingsManager.shared.blurMode.value?.rawValue ?? 0
    blurModeSelector.rx.value
      .skip(1)
      .subscribe(onNext: { index in
        SettingsManager.shared.blurMode.value = SettingsManager.BlurMode(rawValue: index)
      }).disposed(by: disposeBag)
    
    themeModeLabel.text = NSLocalizedString("Theme mode", comment: "")
    themeModeSelector.insertSegment(withTitle: "Dark", at: 0, animated: false)
    themeModeSelector.insertSegment(withTitle: "Normal", at: 0, animated: false)
    themeModeSelector.selectedSegmentIndex = SettingsManager.shared.themeMode.value?.rawValue ?? 0
    themeModeSelector.rx.value
      .skip(1)
      .subscribe(onNext: { [weak self] index in
        if let newTheme = SettingsManager.ThemeMode(rawValue: index) {
          SettingsManager.shared.themeMode.value = newTheme
          self?.setupStyle(theme: newTheme)
        }
      }).disposed(by: disposeBag)
    
    clearCacheButton.setTitle(NSLocalizedString("Clear cache", comment: ""), for: .normal)
    clearCacheButton.rx.tap
      .subscribe(onNext: { [weak self] in
        KingfisherManager.shared.cache.clearDiskCache()
        self?.loadCacheSize()
      }).disposed(by: disposeBag)
  }
  
  private func loadCacheSize() {
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
