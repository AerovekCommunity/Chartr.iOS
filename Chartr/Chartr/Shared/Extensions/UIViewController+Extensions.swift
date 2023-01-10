//
//  UIViewController+Extensions.swift
//  Chartr
//
//  Created by Jay Martinez on 6/7/22.
//

import UIKit

extension UIViewController {
    @objc
    func popController() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(
        _ title: String,
        _ message: String,
        _ primaryActionTitle: String,
        _ secondaryActionTitle: String? = nil,
        _ primaryAction: @escaping ((UIAlertAction) -> Void),
        _ secondaryAction: ((UIAlertAction) -> Void)? = nil) {
            
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: primaryActionTitle, style: .default, handler: primaryAction))
        
        if let secondaryAction = secondaryAction {
            alert.addAction(UIAlertAction(title: secondaryActionTitle, style: .default, handler: secondaryAction))
        }
            
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboardOnViewTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
