//
//  MockPokemonTcgAllSetsApiClient.swift
//  project-squirrel-dragonTests
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

class MockPokemonTcgAllSetsApiClient: PokemonTcgAllSetsApiClientProtocol {

    var apiCallResult: Result<PokemonSetsData> = .failure(URLError(.badServerResponse))

    func fetch(then handler: @escaping PokemonTcgAllSetsApiClientResultBlock) {
        handler(apiCallResult)
    }

}
