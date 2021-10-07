//
//  PokemonCollectionSetsRepository.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

class PokemonCollectionSetsRepository: RepositoryProtocol {

    // MARK: - Properties
    var state: RepositoryState = .loading
    var errorMessage = ""

    private var pokemonTcgAllSetsApiClient: PokemonTcgAllSetsApiClientProtocol
    private (set) var pokemonCollectionSets: [PokemonCollectionSet] = []

    // MARK: - Initialization
    init(pokemonTcgAllSetsApiClient: PokemonTcgAllSetsApiClientProtocol) {
        self.pokemonTcgAllSetsApiClient = pokemonTcgAllSetsApiClient
    }

    // MARK: - Repository Protocol Implementation
    func fetch() {
        pokemonTcgAllSetsApiClient.fetch { [weak self] result in
            switch result {
            case .success(let collectSetsData):
                self?.state = .success
                self?.pokemonCollectionSets = collectSetsData.data.map(PokemonCollectionSet.init)
            case .failure(let error):
                self?.state = .error
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}
