//
//  PokemonCollectionSetsRepository.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

class PokemonCollectionSetsRepository: RepositoryProtocol {


    // MARK: - Properties
    private var error: URLError?

    private var pokemonTcgAllSetsApiClient: PokemonTcgAllSetsApiClientProtocol
    private (set) var pokemonCollectionSets: [PokemonCollectionSet] = []
    private var firebase: FirebaseApiClientProtocol!
    
    // MARK: - Initialization
    init(pokemonTcgAllSetsApiClient: PokemonTcgAllSetsApiClientProtocol = PokemonTcgAllSetsApiClient()) {
        self.pokemonTcgAllSetsApiClient = pokemonTcgAllSetsApiClient
    }

    // MARK: - Repository Protocol Implementation
    func fetch(then handler: @escaping AnyResultBlock) {
        pokemonTcgAllSetsApiClient.fetch  { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let collectSetsData):
                    self?.pokemonCollectionSets = collectSetsData.data.map(PokemonCollectionSet.init)
                    handler(.success(self?.pokemonCollectionSets ?? []))
                case .failure(let error):
                    self?.error = error
                    handler(.failure(error))
                }
            }
        }
    }

    func post(_ item: Any, withPostId postId: String, then handler: @escaping AnyResultBlock) {}
    func delete(_ item: Any, then handler: @escaping AnyResultBlock) {}
}
