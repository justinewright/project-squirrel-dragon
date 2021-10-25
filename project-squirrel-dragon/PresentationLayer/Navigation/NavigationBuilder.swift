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
        rootView.navigationItem.largeTitleDisplayMode = .automatic
        let navigationController = UINavigationController(rootViewController: rootView)
        let navBar = navigationController.navigationBar
        navBar.backgroundColor = .black
        navBar.isTranslucent = false
        navBar.prefersLargeTitles = true
        navBar.barTintColor = .black
        navBar.titleTextAttributes = textStyleAttributes
        navBar.largeTitleTextAttributes = textStyleAttributes
        navigationController.view.backgroundColor = .black
        return navigationController
    }
}
