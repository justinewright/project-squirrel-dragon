//
//  PokemonCollectionSetsViewModel.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/07.
//

import Foundation

protocol PokemonCollectionViewModelDelegate: AnyObject {
    func isLoadingPokemonCollectionSetsViewModel(_ pokemonCollectionSetsViewModel: PokemonCollectionSetsViewModel)
    func didLoadPokemonCollectionSetsViewModel(_ pokemonCollectionSetsViewModel: PokemonCollectionSetsViewModel)
    func didFailWithError(message: String)
}

class PokemonCollectionSetsViewModel {

    // MARK: - Properties
    private weak var delegate: PokemonCollectionViewModelDelegate?
    private var repository: PokemonCollectionSetsRepository
    private (set) var pokemonCollectionSets: [String: PokemonCollectionSet] = [:]

    // MARK: - Initialization
    init(pokemonCollectionViewModelDelegate: PokemonCollectionViewModelDelegate, repository: PokemonCollectionSetsRepository) {
        delegate = pokemonCollectionViewModelDelegate
        self.repository = repository
    }

    func updateView() {
        delegate?.isLoadingPokemonCollectionSetsViewModel(self)
        repository.fetch { [weak self] result in
            switch result {
            case .success(let pokemonCollectionSets):
                self?.pokemonCollectionSets =  Dictionary(uniqueKeysWithValues: pokemonCollectionSets.map { ($0.id, $0) })
                self?.delegate?.didLoadPokemonCollectionSetsViewModel(self!)

            case .failure(let error):
                self?.delegate?.didFailWithError(message: error.localizedDescription)

            }
        }
    }

}
