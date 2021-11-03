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
    private var pokemonSetsRepository: RepositoryProtocol
    private var userSetsRepository: RepositoryProtocol

    // MARK: - Other Properties
    private var pokemonCollectionSets: [String: PokemonCollectionSet] = [:]
    private(set) var userPokemonCollectionSets: [String: UserSet] = [:]
    private var setKeys: [String] = []
    var filteredList: [String] = []
    var sets: [String: PokemonCollectionSet] {
        filteredList.isEmpty ? pokemonCollectionSets.filter{
            Array(userPokemonCollectionSets.keys).contains($0.key) }
        :
        pokemonCollectionSets.filter{ filteredList.description.lastSubString.contains($0.key) }
    }


    // MARK: - Initialization
    init(pokemonCollectionViewModelDelegate: PokemonCollectionViewModelDelegate, pokemonSetsRepository: RepositoryProtocol, userSetsRepository: RepositoryProtocol) {
        delegate = pokemonCollectionViewModelDelegate
        self.pokemonSetsRepository = pokemonSetsRepository
        self.userSetsRepository = userSetsRepository
    }

    func addSet(setID: String) {
        self.userPokemonCollectionSets[setID] = UserSet(id: setID, cardsCollected: 0)
        setKeys = Array(sets.keys)
    }

    func removeSet(setID: String) {
        self.userPokemonCollectionSets.removeValue(forKey: setID)
        setKeys = Array(sets.keys)
    }

    func fetchViewData() {
        userSetsRepository.fetch { [weak self] result1 in
            switch result1 {
            case .success(let userSets):
                self?.pokemonSetsRepository.fetch { [weak self] result2 in
                    switch result2 {
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

//    var userSearchList: [String] {
//        pokemonCollectionSets.map { description(ofPokemonSet: $0.value) }
//    }

    var searchList: [String] {
        pokemonCollectionSets.map { description(ofPokemonSet: $0.value) }
    }

    var userSearchList: [String] {
        pokemonCollectionSets.filter{
            Array(userPokemonCollectionSets.keys).contains($0.key) }.map{description(ofPokemonSet: $0.value)}
    }

    var keys: [String] {
        setKeys
    }

    var selectableSets: [SelectableSet] {
        var s: [SelectableSet] = []
        pokemonCollectionSets.forEach {s.append(SelectableSet(pokemonSet: pokemonCollectionSets[$0.key]!, userSet: userPokemonCollectionSets[$0.key]))
        }
        return s
    }

}
