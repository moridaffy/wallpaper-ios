//
//  UIViewController+Alerts.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 13/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func embedInNavigationController() -> UINavigationController {
    return ThemedNavigationController(rootViewController: self)
  }
  
  func showAlert(title: String?, body: String?, button: String?, actions: [UIAlertAction]?) {
    let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
    actions?.compactMap { $0 }.forEach { alert.addAction($0) }

    if let button = button {
      let lastButton = UIAlertAction(title: button, style: .cancel)
      alert.addAction(lastButton)
    }
    
    if let popoverPresentationController = alert.popoverPresentationController {
      popoverPresentationController.sourceView = view
      popoverPresentationController.sourceRect = CGRect(x: view.bounds.size.width / 2.0, y: view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
      popoverPresentationController.permittedArrowDirections = [.down]
    }

    present(alert, animated: true)
  }
  
  func showAlertError(error: Error?, desc: String?, critical: Bool) {
    var body = desc ?? NSLocalizedString("Unknown error occured", comment: "")
    if let error = error {
      body += "\n" + NSLocalizedString("Description", comment: "") + ": \(error.localizedDescription)"
    }
    let button = critical ? nil : "Ок"
    
    showAlert(title: NSLocalizedString("Error", comment: ""), body: body, button: button, actions: nil)
  }
  
}
