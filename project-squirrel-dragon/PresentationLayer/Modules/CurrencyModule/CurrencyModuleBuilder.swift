//
//  CurrencyModuleBuilder.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/12/14.
//

import Foundation

class CurrencyModuleBuilder {

    static func build(usingNavigationFactory factory: NavigationFactory) -> UINavigationController {
        let viewName = "Currency"
        let storyboard = UIStoryboard.init(name: viewName, bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: viewName)
        view.title = viewName
        view.navigationItem.largeTitleDisplayMode = .always
        
        view.navigationController?.isNavigationBarHidden = true
        return factory(view)
    }

}
