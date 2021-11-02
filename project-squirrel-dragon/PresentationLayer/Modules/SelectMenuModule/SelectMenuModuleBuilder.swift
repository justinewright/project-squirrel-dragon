//
//  SelectMenuBuilder.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/02.
//

import Foundation

class SelectMenuModuleBuilder {
    static func build(usingNavigationFactory factory: NavigationFactory, andPokemonSet set: [SelectableSet]) -> UINavigationController {
        // TODO: - add navigation builder
        let storyboard = UIStoryboard.init(name: "SelectMenu", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "SelectMenu")
        view.navigationItem.largeTitleDisplayMode = .never

        //user set
        if let view = view as? SelectMenuViewController {
            view.setList(withNewList: set)
        }
        return factory(view)
    }
}
