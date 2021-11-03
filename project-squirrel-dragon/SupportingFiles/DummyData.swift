//
//  DummyData.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/21.
//

import Foundation

struct DummyData {
    static let pokemonSetData = SetsData(id: "base1",
                                      name: "Base",
                                      series: "Base",
                                      printedTotal: 102,
                                      total: 102,
                                      releaseDate: "1999/01/09",
                                      updatedAt: "2020/08/14 09:35:00",
                                      images: Images(symbol: "https://images.pokemontcg.io/base1/symbol.png",
                                                     logo: "https://images.pokemontcg.io/base1/logo.png"))

    static let userSet = UserSet(userSetData: userSetData)
    static let pokemonSet = SetDetails(id: "base1",
                            userSet: userSet,
                            pokemonCollectionSet: PokemonCollectionSet(pokemonSetsData: pokemonSetData))

    static var userSetData = UserSetData(id: "base1", collectedCards: 55, cardData: [])

}
