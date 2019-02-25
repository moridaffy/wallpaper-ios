//
//  SettingsViewController .swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 13/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  private weak var blurModeLabel: UILabel!
  private weak var blurModeSelector: UISegmentedControl!
  private weak var cropModeLabel: UILabel!
  private weak var cropModeSelector: UISegmentedControl!
  
  private let model = SettingsViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
}
