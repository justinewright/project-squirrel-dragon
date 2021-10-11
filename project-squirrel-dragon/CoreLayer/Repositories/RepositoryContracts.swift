//
//  RepositoryContracts.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

enum RepositoryState {
    case loading
    case success
    case error
}

protocol RepositoryProtocol {
    func fetch(then handler: @escaping PokemonCollectionSetResultBlock)
}

typealias PokemonCollectionSetResultBlock = (Result<[PokemonCollectionSet], URLError>) -> Void

