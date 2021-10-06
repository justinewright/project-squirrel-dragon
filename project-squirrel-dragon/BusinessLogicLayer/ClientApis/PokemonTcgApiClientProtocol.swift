//
//  PokemonTcgAPIClientProtocol.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation
import Combine

enum Result<PokemonSetsData> {
    case success(PokemonSetsData)
    case failure(URLError)
}

protocol PokemonTcgApiClientProtocol {
    func fetch(then handler: @escaping (Result<PokemonSetsData>) -> Void)
}
