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
    func fetch(then handler: @escaping AnyResultBlock)
    func post(_ item: Any, withPostId postId: String, then handler: @escaping AnyResultBlock)
    func delete(_ item: Any, then handler: @escaping AnyResultBlock)
}

typealias PokemonCollectionSetResultBlock = (Result<[PokemonCollectionSet], URLError>) -> Void

typealias AnyResultBlock = (Result<Any, URLError>) -> Void
