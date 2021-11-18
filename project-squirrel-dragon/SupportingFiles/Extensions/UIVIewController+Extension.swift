//
//  UIVIewController_Extension.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/25.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(titled: String, with message: String) {
        let alert = UIAlertController(title: titled, message: message, preferredStyle: .alert)
        let alertOKAction=UIAlertAction(title: "OK", style: .default, handler: { _ in })
        alert.addAction(alertOKAction)
        present(alert, animated: true, completion: nil)
    }

    func showSelectAlert(titled: String, with message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: titled, message: message, preferredStyle: .alert)
        let alertOKAction = UIAlertAction(title: "Select More Sets...", style: .default, handler: handler)
        let alertCancelAction = UIAlertAction(title: "Keep Current Selection", style: .default, handler: { _ in })
        alert.addAction(alertOKAction)
        alert.addAction(alertCancelAction)
        present(alert, animated: true, completion: nil)
    }

    func showAlertWithUITextField(titled: String,
                                  withMessage message: String,
                                  andPlaceHolder placeholder: String,
                                  handler: (UITextField) -> (UIAlertAction) -> Void) {
        var textField = UITextField()
        let alert = UIAlertController(title: titled, message: message, preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = placeholder
            textField = alertTextField
            alertTextField.keyboardType = .numberPad
        }

        let doneAction = UIAlertAction(title: "Done", style: .default, handler: handler(textField))
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { _ in })
        alert.addAction(cancelAction)
        alert.addAction(doneAction)

        present(alert, animated: true, completion: nil)
    }

}
