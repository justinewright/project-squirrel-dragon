//
//  PokemonTcgAllSetsApiClientProtocol.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/08.
//

import Foundation

typealias ApiClientResultBlock = (Result<Any, URLError>) -> Void

protocol PokemonTcgApiClientProtocol{

    func fetch(then handler: @escaping ApiClientResultBlock)
}
