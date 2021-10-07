//
//  PokemonCollectionSetsViewModel.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/07.
//

import Foundation

protocol PokemonCollectionViewModelDelegate: AnyObject {
    func isLoadingPokemonCollectionSetsViewModel(_ pokemonCollectionSetsViewModel: PokemonCollectionSetsViewModel)
    func didLoadPokemonCollectionSetsViewModel(_ pokemonCollectionSetsViewModel: PokemonCollectionSetsViewModel, pokemonCollectionSets: [PokemonCollectionSet])
    func didFailWithError(message: String)
}

class PokemonCollectionSetsViewModel {
    // MARK: - Properties
    weak var delegate: PokemonCollectionViewModelDelegate?
    private lazy var repository = PokemonCollectionSetsRepository()
    private (set) var pokemonCollectionSets: [PokemonCollectionSet] = []

    // MARK: - Initialization
    init() {
        repository.viewModel = self
        repository.fetch()
        updateView()
    }

    private func updateView() {
        switch repository.state {
        case .success:
            delegate?.didLoadPokemonCollectionSetsViewModel(self, pokemonCollectionSets: pokemonCollectionSets)
        case .error:
            delegate?.didFailWithError(message: repository.errorMessage)
        case .loading:
            delegate?.isLoadingPokemonCollectionSetsViewModel(self)
        }
    }
}

// MARK: - Repository To View Model Protocol
extension PokemonCollectionSetsViewModel: RepositoryToViewModelProtocol {
    func fetchedData(models: [BaseModel]) {
        guard let pokemonCollectionSets = models as? [PokemonCollectionSet] else {
            return
        }
        self.pokemonCollectionSets = pokemonCollectionSets
        updateView()
    }

}
