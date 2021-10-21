//
//  NavigationBuilder.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/21.
//

import UIKit

typealias NavigationFactory = (UIViewController) -> (UINavigationController)

class NavigationBuilder {
    static func build(rootView: UIViewController) -> UINavigationController {
        let textStyleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
//        let textStyleAttributes: [NSAttributedString.Key: Any] = [
//            .foregroundColor: UIColor.white
//        ]
        rootView.navigationItem.largeTitleDisplayMode = .automatic
        let navigationController = UINavigationController(rootViewController: rootView)
        let navBar = navigationController.navigationBar
//        navBar.barTintColor = .clear
        navBar.backgroundColor = .black
        navBar.isTranslucent = false
        navBar.prefersLargeTitles = true
        navBar.barTintColor = .black
        navBar.titleTextAttributes = textStyleAttributes
        navBar.largeTitleTextAttributes = textStyleAttributes
        navigationController.view.backgroundColor = .black
//        let width = UIScreen.main.bounds.width
//        let height = UIScreen.main.bounds.height
//        rootView.view.frame = CGRect(x: width * 0.1 / 2, y: height * 0.1 / 2, width: width * 0.8, height: height * 0.8)
//        rootView.view.layer.masksToBounds = true
//        rootView.view.layer.cornerRadius = 20

        return navigationController
    }
}
