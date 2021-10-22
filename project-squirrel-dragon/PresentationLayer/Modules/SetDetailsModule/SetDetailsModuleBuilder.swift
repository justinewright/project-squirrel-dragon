//
//  SetDetailsModuleBuilder.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/20.
//

import Foundation

class SetDetailsModuleBuilder {
    static func build(usingNavigationFactory factory: NavigationFactory, andPokemonSet set:PokemonCollectionSet) -> UIViewController {
        // TODO: - add navigation builder
        let storyboard = UIStoryboard.init(name: "SetDetails", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "SetDetails")
        view.title = set.name
        view.navigationItem.largeTitleDisplayMode = .never
        if let view = view as? SetDetailsViewController {
            let viewModel = SetDetailsViewModel(setDetails: SetDetails(id: set.id,
                                                                       userSet: UserSet(id: set.id,
                                                                                       cardsCollected: 0),
                                                                       pokemonCollectionSet: set),
                                                delegate: view)
            view.configure(withViewModel: viewModel)
        }
        return view
    }
}
