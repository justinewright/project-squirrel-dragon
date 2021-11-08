//
//  PokemonTcgAllSetsApiClientProtocol.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/08.
//

import Foundation

typealias PokemonTcgApiClientResultBlock<T:Codable> = (Result<T, URLError>) -> Void

protocol PokemonTcgApiClientProtocol {
    associatedtype Response: Codable

    func fetch(then handler: @escaping PokemonTcgApiClientResultBlock<Response>)
}
