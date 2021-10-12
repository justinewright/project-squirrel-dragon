//
//  CustomSearchBarModuleBuilder.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/12.
//

import UIKit

class CustomSearchBarModuleBuilder {
    static func build() -> UIViewController {
        // TODO: - add navigation builder
        let storyboard = UIStoryboard.init(name: "CustomSearchBarViewController", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "CustomSearchBarViewController")
        // return factory of the view
        return view
    }
}
