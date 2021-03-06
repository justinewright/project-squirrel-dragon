//
//  PokemonCollectionSetsModuleBuilder.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/07.
//

import UIKit

class PokemonCollectionSetsModuleBuilder {
    static func build(usingNavigationFactory factory: NavigationFactory) -> UINavigationController {
        // TODO: - add navigation builder
        let storyboard = UIStoryboard.init(name: "PokemonCollectionSets", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "PokemonCollectionSetsViewController")
        view.title = "Sets"
        return factory(view)
    }
}
