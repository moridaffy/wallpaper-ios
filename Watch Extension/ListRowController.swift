//
//  ListRowController.swift
//  Watch Extension
//
//  Created by Максим Скрябин on 07/03/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import WatchKit

class ListRowController: NSObject {
  
  @IBOutlet weak var imageView: WKInterfaceImage!
  
  var image: UIImage? {
    didSet {
      imageView.setImage(image)
    }
  }
  
}
