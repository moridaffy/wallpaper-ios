//
//  ListInterfaceController.swift
//  Watch Extension
//
//  Created by Максим Скрябин on 07/03/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import WatchKit

class ListInterfaceController: WKInterfaceController {
  
  @IBOutlet private weak var table: WKInterfaceTable!
  @IBOutlet weak var loadingLabel: WKInterfaceLabel!
  
  private var wallpapers: [UIImage] = []
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    var imageParsed: Int = 0
    
    setupLabel()
    APIManager.loadImages(search: nil) { (searchCodable, error) in
      for hit in searchCodable?.hits ?? [] {
        APIManager.loadImage(urlString: hit.webformatURL, result: { (data) in
          imageParsed += 1
          if let data = data, let image = UIImage(data: data) {
            self.wallpapers.append(image)
          }
          if imageParsed == SettingsManager.shared.perPage.value {
            self.setupTable()
          }
        })
      }
    }
  }
  
  private func setupLabel() {
    loadingLabel.setText("Loading...")
  }
  
  private func setupTable() {
    loadingLabel.setHidden(true)
    table.setNumberOfRows(wallpapers.count, withRowType: "ListRow")
    for i in 0..<wallpapers.count {
      guard let rowController = table.rowController(at: i) as? ListRowController else { continue }
      rowController.image = wallpapers[i]
    }
  }
}
