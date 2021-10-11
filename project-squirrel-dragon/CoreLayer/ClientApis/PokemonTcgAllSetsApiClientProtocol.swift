//
//  PokemonTcgApiClientProtocol.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

typealias PokemonTcgAllSetsApiClientResultBlock = (Result<PokemonSetsData, URLError>) -> Void

protocol PokemonTcgAllSetsApiClientProtocol {
    func fetch(then handler: @escaping PokemonTcgAllSetsApiClientResultBlock)
}
