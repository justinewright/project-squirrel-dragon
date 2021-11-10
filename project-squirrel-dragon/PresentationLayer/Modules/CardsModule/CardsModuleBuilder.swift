//
//  CardsModuleBuilder.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/10.
//

import Foundation

class CardsModuleBuilder {

    static func build(usingNavigationFactory factory: NavigationFactory, andPokemonSet set:PokemonCollectionSet) -> UIViewController {
        let storyboard = UIStoryboard.init(name: "Cards", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "Cards")
        view.title = set.name + "'s Cards"
        view.navigationItem.largeTitleDisplayMode = .never
        return view
        
    }

}
