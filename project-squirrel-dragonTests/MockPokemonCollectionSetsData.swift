//
//  MockPokemonCollectionData.swift
//  project-squirrel-dragonTests
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

let mockSetData = SetsData(id: "base1", name: "Base", series: "Base", printedTotal: 102, total: 102, releaseDate: "1999/01/09", updatedAt: "2020/08/14 09:35:00", images: Images(symbol: "https://images.pokemontcg.io/base1/symbol.png", logo: "https://images.pokemontcg.io/base1/logo.png"))

let mockPokemonCollectionSetsData = PokemonSetsData(data: [mockSetData])
