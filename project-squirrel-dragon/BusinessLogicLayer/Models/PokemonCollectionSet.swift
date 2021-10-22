//
//  PokemonCollectionSet.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

struct PokemonCollectionSet: BaseModel {
    var model: Any { get
        { return self }
    }

    let id: String
    let name: String
    let series: String
    let printedTotal: Int
    let total: Int
    let releaseDate: String
    let updatedAt: String 
    let imageSymbol: String
    let imageLogo: String

    init(pokemonSetsData: SetsData) {
        id = pokemonSetsData.id
        name = pokemonSetsData.name
        series = pokemonSetsData.series
        printedTotal = pokemonSetsData.printedTotal
        total = pokemonSetsData.total
        releaseDate = pokemonSetsData.releaseDate
        updatedAt = pokemonSetsData.updatedAt
        imageSymbol = pokemonSetsData.images.symbol
        imageLogo = pokemonSetsData.images.logo
    }

    var description: String {
    """
    name: \(name)
    series: \(series)
    id: \(id)
    """
    }

}
