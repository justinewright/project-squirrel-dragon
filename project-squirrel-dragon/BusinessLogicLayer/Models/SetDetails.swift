//
//  SetDetails.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/20.
//

import Foundation

struct SetDetails {
    let id: String
    let userSet: UserSet
    let pokemonCollectionSet: PokemonCollectionSet

    var collectedFraction: String {
        "\(userSet.cardsCollected)/\(pokemonCollectionSet.total)"
    }

    var collectedPercentage: String {
        "\((userSet.cardsCollected)/(pokemonCollectionSet.total)*100)%"
    }
}
