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

    fileprivate func setSearchPath(_ searchId: String) {
        if let userSetsRepository = userSetsRepository as? UserPokemonSetsRepository {
            userSetsRepository.setSearchPath(as: "sets")
        }
    }

    func addSet(setIDs: [String]) {
        setIDs.forEach {
            setSearchPath($0)
            userSetsRepository.post(
                UserSetData(id: $0, collectedCards: 0, cardData: []).toAnyObject(), withPostId: $0) { [weak self] result in
            switch result {

            case .success(let userSets):
                guard let userSets =  userSets as? DataSnapshot else {
                    self?.delegate?.didFailWithError(message: "bads")
                    return
                }

                userSets.children.forEach {
                    guard let u =  $0 as? DataSnapshot else {
                        self?.delegate?.didFailWithError(message: "bads")
                        return
                    }
                    let newUserSet = UserSet(snapshot: u)
                    self?.userPokemonCollectionSets[newUserSet.id] = newUserSet
                }
                 self?.setKeys = Array((self?.sets.keys)!)
                self?.delegate?.didLoadPokemonCollectionSetsViewModel(self!)
            case .failure(let error):
                self?.delegate?.didFailWithError(message: error.localizedDescription)
            }
        }
        }
    }

    func removeSet(setIDs: [String]) {
        setIDs.forEach {
            setSearchPath($0)
            userSetsRepository.delete($0) { [weak self] result in
            switch result {
            case .success(let userSets):
                guard let userSets =  userSets as? DataSnapshot else {
                    self?.delegate?.didFailWithError(message: "bads a")
                    return
                }
                self?.userPokemonCollectionSets.removeAll()
                userSets.children.forEach {
                    guard let u =  $0 as? DataSnapshot else {
                        self?.delegate?.didFailWithError(message: "bads b")
                        return
                    }
                    let newUserSet = UserSet(snapshot: u)
                    self?.userPokemonCollectionSets[newUserSet.id] = newUserSet
                }
                 self?.setKeys = Array((self?.sets.keys)!)
                self?.delegate?.didLoadPokemonCollectionSetsViewModel(self!)
            case .failure(let error):
                self?.delegate?.didFailWithError(message: error.localizedDescription)
            }
        }
        }
    }

    func fetchViewData() {
        setSearchPath("")
        userSetsRepository.fetch { [weak self] result1 in
            switch result1 {
            case .success(let userSets):
                self?.pokemonSetsRepository.fetch { [weak self] result2 in
                    switch result2 {
                    case .success(let pokemonCollectionSets):
                        guard let pokemonCollectionSets = pokemonCollectionSets as? [PokemonCollectionSet] else {
                            self?.delegate?.didFailWithError(message: "Failed to cast data to PokemonCollectionSet")
                            return
                        }
                        self?.pokemonCollectionSets = Dictionary(uniqueKeysWithValues: pokemonCollectionSets.map { ($0.id, $0) })
//                        self?.delegate?.didLoadPokemonCollectionSetsViewModel(self!)
                        guard let userSets =  userSets as? DataSnapshot else {
                            self?.delegate?.didFailWithError(message: "bads")
                            return
                        }

                        userSets.children.forEach {
                            guard let u =  $0 as? DataSnapshot else {
                                self?.delegate?.didFailWithError(message: "bads")
                                return
                            }
                            let newUserSet = UserSet(snapshot: u)
                            self?.userPokemonCollectionSets[newUserSet.id] = newUserSet

                        }
                        self?.setKeys = Array((self?.sets.keys)!)
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

    var searchList: [String] {
        pokemonCollectionSets.map { description(ofPokemonSet: $0.value) }
    }

    var userSearchList: [String] {
        pokemonCollectionSets.filter{
            Array(userPokemonCollectionSets.keys).contains($0.key) }.map{description(ofPokemonSet: $0.value)}
    }

    var keys: [String] {
        filteredList.isEmpty ? setKeys : filteredList.map{$0.lastSubString}
    }

    var selectableSets: [SelectableSet] {
        var s: [SelectableSet] = []
        pokemonCollectionSets.forEach {s.append(SelectableSet(pokemonSet: pokemonCollectionSets[$0.key]!, userSet: userPokemonCollectionSets[$0.key]))
        }
        return s
    }

}
