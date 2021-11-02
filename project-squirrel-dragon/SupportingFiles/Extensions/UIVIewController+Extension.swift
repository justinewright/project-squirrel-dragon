//
//  UIVIewController_Extension.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/25.
//

import Foundation

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

}
