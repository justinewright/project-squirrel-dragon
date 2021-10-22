//
//  PokemonCollectionSetsViewModel.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/07.
//

import Foundation

protocol PokemonCollectionViewModelDelegate: AnyObject {
    func didLoadPokemonCollectionSetsViewModel(_ pokemonCollectionSetsViewModel: PokemonCollectionSetsViewModel)
    func didFailWithError(message: String)
}

class PokemonCollectionSetsViewModel {

    // MARK: - Properties
    private weak var delegate: PokemonCollectionViewModelDelegate?
    private var repository: PokemonCollectionSetsRepository
    private var pokemonCollectionSets: [String: PokemonCollectionSet] = [:]
    var filteredList: [String] = []
    var sets: [String: PokemonCollectionSet] {
        filteredList.isEmpty ? pokemonCollectionSets :
        pokemonCollectionSets.filter{ filteredList.description.lastSubString.contains( $0.key) }
    }

    // MARK: - Initialization
    init(pokemonCollectionViewModelDelegate: PokemonCollectionViewModelDelegate, repository: PokemonCollectionSetsRepository) {
        delegate = pokemonCollectionViewModelDelegate
        self.repository = repository
    }

    func updateView() {
        repository.fetch { [weak self] result in
            switch result {
            case .success(let pokemonCollectionSets):
                guard let pokemonCollectionSets = pokemonCollectionSets as? [PokemonCollectionSet] else {
                    self?.delegate?.didFailWithError(message: "Some error occured")
                    return
                }
                self?.pokemonCollectionSets = Dictionary(uniqueKeysWithValues: pokemonCollectionSets.map { ($0.id, $0) })
                self?.delegate?.didLoadPokemonCollectionSetsViewModel(self!)

            case .failure(let error):
                self?.delegate?.didFailWithError(message: error.localizedDescription)

            }
        }
    }

    var searchList: [String] {
        pokemonCollectionSets.map { $0.value.description }
    }

    var keys: [String] {
        Array(sets.keys)
    }

}
