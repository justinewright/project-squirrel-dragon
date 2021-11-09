//
//  SelectMenuBuilder.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/02.
//

import Foundation

class SelectMenuModuleBuilder {
    static func build(usingNavigationFactory factory: NavigationFactory, andViewModel viewModel: PokemonCollectionSetsViewModel) -> UINavigationController {

        let storyboard = UIStoryboard.init(name: "SelectMenu", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "SelectMenu")
        view.navigationItem.largeTitleDisplayMode = .never
        if let view = view as? SelectMenuViewController {
            view.setList(withNewList: viewModel.selectableSets)
            view.setSearchList(withSearchList: viewModel.searchList)
        }
        return factory(view)
    }
}
