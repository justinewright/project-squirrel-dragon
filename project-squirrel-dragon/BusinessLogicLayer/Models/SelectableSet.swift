//
//  SetSelectionTracker.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/28.
//

import Foundation

struct SelectableSet {
    let id: String
    let series: String
    let url: String
    var selected: Bool

    init (pokemonSet: PokemonCollectionSet, userSet: UserSet?) {
        self.id = pokemonSet.id
        self.series = pokemonSet.series
        self.url = pokemonSet.imageLogo
        self.selected = userSet != nil
    }
}
