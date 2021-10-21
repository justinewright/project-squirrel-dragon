//
//  TabBarBuilder.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/21.
//

import UIKit

typealias Submodules = (
    sets: UINavigationController,
    money: UINavigationController
)

typealias MainTabs = (
    sets: UINavigationController,
    money: UINavigationController
)

class TabBarBuilder {

    static func build(usingSubmodules submodules: Submodules) -> UITabBarController {
        let tabBarController = styledTabBarController.self
        let tabItems = tabs(usingSubmodules: submodules)
        tabBarController.viewControllers = [tabItems.sets, tabItems.cards, tabItems.money]

        return tabBarController
    }

    static func tabs(usingSubmodules submodules: Submodules) -> MainTabs {
        let setsTabBarItem =  createTabItem(title: "sets", tabImage: UIImage(systemName: "circle.grid.3x3.circle")!)
        let moneyTabBarItem =  createTabItem(title: "money", tabImage: UIImage(systemName: "dollarsign.circle.fill")!)

        submodules.sets.tabBarItem = setsTabBarItem
        submodules.money.tabBarItem = moneyTabBarItem

        return (
            sets: submodules.sets,
            money: submodules.money
        )
    }

    private static func createTabItem(title: String, tabImage: UIImage) -> UITabBarItem {
        UITabBarItem(title: title,
                     image: tabImage.withTintColor(.gray, renderingMode: .alwaysOriginal),
                     selectedImage: tabImage.withTintColor(.white, renderingMode: .alwaysOriginal))
    }

    static var styledTabBarController: UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.barTintColor = .black
        tabBarController.tabBar.unselectedItemTintColor = .gray
        tabBarController.tabBar.tintColor = .white
        let textStyleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        tabBarController.tabBarItem.setTitleTextAttributes(textStyleAttributes, for: .selected)
        return tabBarController
    }

}
