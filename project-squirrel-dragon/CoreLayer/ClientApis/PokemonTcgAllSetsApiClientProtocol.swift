//
//  PokemonTcgApiClientProtocol.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

enum Result<PokemonSetsData> {
    case success(PokemonSetsData)
    case failure(URLError)
}

typealias PokemonTcgAllSetsApiClientResultBlock = (Result<PokemonSetsData>) -> Void

protocol PokemonTcgAllSetsApiClientProtocol {
    func fetch(then handler: @escaping PokemonTcgAllSetsApiClientResultBlock)
}
