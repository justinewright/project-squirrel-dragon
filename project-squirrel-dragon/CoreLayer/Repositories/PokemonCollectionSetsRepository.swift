//
//  PokemonCollectionSetsRepository.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

class PokemonCollectionSetsRepository: RepositoryProtocol {

    // MARK: - Properties
    private var state: RepositoryState = .loading
    private var error: URLError?
    private var viewModel: PokemonCollectionSetsViewModel?

    private var pokemonTcgAllSetsApiClient: PokemonTcgAllSetsApiClientProtocol
    private (set) var pokemonCollectionSets: [PokemonCollectionSet] = []

    // MARK: - Initialization
    init(pokemonTcgAllSetsApiClient: PokemonTcgAllSetsApiClientProtocol = PokemonTcgAllSetsApiClient(), pokemonCollectionSetsViewModel: PokemonCollectionSetsViewModel? = nil) {
        self.pokemonTcgAllSetsApiClient = pokemonTcgAllSetsApiClient
    }

    // MARK: - Repository Protocol Implementation
    func fetch(then handler: @escaping AnyResultBlock) {
        pokemonTcgAllSetsApiClient.fetch  { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let collectSetsData):
                    self?.state = .success

                    self?.pokemonCollectionSets = collectSetsData.data.map(PokemonCollectionSet.init)
                    handler(.success(self?.pokemonCollectionSets ?? []))
                case .failure(let error):
                    self?.state = .error
                    self?.error = error
                    handler(.failure(error))
                }
            }
        }
    }
}
