//
//  LoginModuleBuilder.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/26.
//

import Foundation

class LoginModuleBuilder {
    static func build(usingNavigationFactory factory: NavigationFactory) -> UINavigationController {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "Login")
        return factory(view)
    }
}
