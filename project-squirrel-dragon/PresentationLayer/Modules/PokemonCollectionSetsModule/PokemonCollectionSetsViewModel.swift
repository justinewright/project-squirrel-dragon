//
//  PokemonCollectionSetsViewModel.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/07.
//

import Foundation
import Firebase

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
        let userList = pokemonCollectionSets.filter { Array(userPokemonCollectionSets.keys) .contains($0.key)}
        return filteredList.isEmpty ? userList :
        userList.filter{ filteredList.map{ $0.lastSubString }.contains($0.key) }
    }

    // MARK: - Initialization
    init(pokemonCollectionViewModelDelegate: PokemonCollectionViewModelDelegate, pokemonSetsRepository: RepositoryProtocol, userSetsRepository: RepositoryProtocol) {
        delegate = pokemonCollectionViewModelDelegate
        self.pokemonSetsRepository = pokemonSetsRepository
        self.userSetsRepository = userSetsRepository
    }

    func fetchViewData() {
        pokemonSetsRepository.fetch { [weak self] result in
            switch result {
            case .success(let pokemonCollectionSets):
                guard let pokemonCollectionSets = pokemonCollectionSets as? [PokemonCollectionSet] else {
                    self?.delegate?.didFailWithError(message: "Failed to cast data to PokemonCollectionSet")
                    return
                }
                self?.pokemonCollectionSets = Dictionary(uniqueKeysWithValues: pokemonCollectionSets.map { ($0.id, $0) })
            case .failure(let error):
                self?.delegate?.didFailWithError(message: error.localizedDescription)
                return
            }
        }
        setSearchPath("sets")
        userSetsRepository.fetch { [weak self] result in
            self?.processUserSetsResults(withRepositoryResult: result)
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
        filteredList.isEmpty ? setKeys : filteredList.map{$0.lastSubString}
    }

    var selectableSets: [SelectableSet] {
        var selectableSets: [SelectableSet] = []

        pokemonCollectionSets.forEach {selectableSets.append( SelectableSet(id: pokemonCollectionSets[$0.key]!.id,
                                                               series: pokemonCollectionSets[$0.key]!.series,
                                                               url: pokemonCollectionSets[$0.key]!.imageLogo,
                                                               selected: userPokemonCollectionSets[$0.key] != nil))
        }
        return selectableSets
    }
}

// MARK: - User Sets Repository Methods
extension PokemonCollectionSetsViewModel {

    var userSearchList: [String] {
        pokemonCollectionSets.filter{
            Array(userPokemonCollectionSets.keys).contains($0.key) }.map{description(ofPokemonSet: $0.value)}
    }
    func addSet(setIDs: [String]) {
        setIDs.forEach {
            setSearchPath($0)
            userSetsRepository.post(
                UserSetData(id: $0, collectedCards: 0, cardData: []).toAnyObject(), withPostId: $0) { [weak self] result in
                    self?.processUserSetsResults(withRepositoryResult: result)
                }
        }
    }

    func removeSet(setIDs: [String]) {
        setIDs.forEach {
            setSearchPath($0)
            userSetsRepository.delete($0) { [weak self] result in
                self?.processUserSetsResults(withRepositoryResult: result)
            }
        }
    }

    private func setSearchPath(_ searchId: String) {
        if let userSetsRepository = userSetsRepository as? UserPokemonSetsRepository {
            userSetsRepository.setSearchPath(as: "sets")
        }
    }

    private func processUserSetsResults(withRepositoryResult result: Result<Any, URLError> ) {
        switch result {
        case .success(let userSetsData):
            guard let userSetsData =  userSetsData as? [UserSetData] else {
                self.delegate?.didFailWithError(message: "Failed to cast data to UserSetData")
                return
            }
            self.userPokemonCollectionSets.removeAll()
            userSetsData.forEach { userSetData in
                let newUserSet = UserSet(userSetData: userSetData)
                self.userPokemonCollectionSets[newUserSet.id] = newUserSet
            }
            self.setKeys = Array((self.sets.keys))
            self.delegate?.didLoadPokemonCollectionSetsViewModel(self)
        case .failure(let error):
            self.delegate?.didFailWithError(message: error.localizedDescription)
        }
    }

}
