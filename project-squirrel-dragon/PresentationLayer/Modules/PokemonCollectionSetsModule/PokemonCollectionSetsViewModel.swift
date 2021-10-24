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
    private var repository: RepositoryProtocol

    // MARK: - Other Properties
    private var pokemonCollectionSets: [String: PokemonCollectionSet] = [:]
    var filteredList: [String] = []
    var sets: [String: PokemonCollectionSet] {
        filteredList.isEmpty ? pokemonCollectionSets :
        pokemonCollectionSets.filter{ filteredList.description.lastSubString.contains( $0.key) }
    }

    // MARK: - Initialization
    init(pokemonCollectionViewModelDelegate: PokemonCollectionViewModelDelegate, repository: RepositoryProtocol) {
        delegate = pokemonCollectionViewModelDelegate
        self.repository = repository
    }

    func fetchViewData() {
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
    private func description(ofPokemonSet set: PokemonCollectionSet) -> String {
    """
    name: \(set.name)
    series: \(set.series)
    id: \(set.id)
    """
    }

    var searchList: [String] {
        pokemonCollectionSets.map { description(ofPokemonSet: $0.value) }
    }

    var keys: [String] {
        Array(sets.keys)
    }

}
