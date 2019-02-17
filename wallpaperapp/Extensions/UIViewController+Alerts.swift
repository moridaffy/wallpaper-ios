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
    return UINavigationController(rootViewController: self)
  }
  
  func showAlert(title: String?, body: String?, button: String?, actions: [UIAlertAction]?) {
    let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
    for action in (actions ?? []) {
      alert.addAction(action)
    }
    if let button = button {
      let lastButton = UIAlertAction(title: button, style: .cancel, handler: { _ in
        alert.dismiss(animated: true, completion: nil)
      })
      alert.addAction(lastButton)
    }
    
    if let _ = alert.popoverPresentationController {
      alert.popoverPresentationController!.sourceView = self.view
      alert.popoverPresentationController!.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
      alert.popoverPresentationController!.permittedArrowDirections = [.down]
    }
    
    present(alert, animated: true, completion: nil)
  }
  
  func showAlertError(error: Error?, desc: String?, critical: Bool) {
    var body: String = desc ?? NSLocalizedString("Unknown error occured", comment: "")
    if let error = error {
      body += "\n" + NSLocalizedString("Description", comment: "") + ": \(error.localizedDescription)"
    }
    let button: String? = critical ? nil : "Ок"
    
    showAlert(title: NSLocalizedString("Error", comment: ""), body: body, button: button, actions: nil)
  }
  
}
