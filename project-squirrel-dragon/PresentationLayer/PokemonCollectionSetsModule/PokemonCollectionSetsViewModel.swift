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
    weak var delegate: PokemonCollectionViewModelDelegate?
    private lazy var repository = PokemonCollectionSetsRepository()
    private (set) var pokemonCollectionSets: [PokemonCollectionSet] = []

    // MARK: - Initialization
    init(pokemonCollectionViewModelDelegate: PokemonCollectionViewModelDelegate) {
        delegate = pokemonCollectionViewModelDelegate
        repository = PokemonCollectionSetsRepository(pokemonCollectionSetsViewModel: self)
        updateView()
    }

    func updateView() {
        delegate?.isLoadingPokemonCollectionSetsViewModel(self)
        repository.fetch { [weak self] result in
            switch result {
            case .success(let pokemonCollectionSets):
                self?.pokemonCollectionSets = pokemonCollectionSets
                self?.delegate?.didLoadPokemonCollectionSetsViewModel(self!)
            case .failure(let error):
                self?.delegate?.didFailWithError(message: error.localizedDescription)

            }
        }
    }
}
