//
//  CardsCollectionViewModel.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/11.
//

import Foundation

protocol CardsCollectionViewModelDelegate: AnyObject {
    func didLoadCardsCollectionViewModel(_ cardsCollectionViewModel: CardsCollectionViewModel)
    func didFailWithError(message: String)
}

class CardsCollectionViewModel {
    typealias PokemonTCGCards = CardData
    typealias FirebaseUserCards = UserCardData
    // MARK: - Properties
    private weak var delegate: CardsCollectionViewModelDelegate?
    private var pokemonCardsRepository: RepositoryProtocol
    private var userCardsRepository: RepositoryProtocol

    // MARK: - Other Properties
    private(set) var pokemonCards: [String: PokemonTCGCards] = [:]
    private(set) var userPokemonCards: [String: FirebaseUserCards] = [:]
    private var setKeys: [String] = []
    private var setID: String!
    var collectableCards: [CollectableCard] {
        pokemonCards.map { CollectableCard.init(id: $0.key,
                                                pokemonCard: $0.value,
                                                userCard: userPokemonCards[$0.key]) }
    }

    // MARK: - Initialization
    init(delegate: CardsCollectionViewModelDelegate,
         pokemonCardsRepository: RepositoryProtocol,
         userCardsRepository: RepositoryProtocol) {
        self.delegate = delegate
        self.pokemonCardsRepository = pokemonCardsRepository
        self.userCardsRepository = userCardsRepository
    }

    func fetchViewData() {
        pokemonCardsRepository.fetch(itemWithID: setID) { [weak self] result in
            switch result {
            case .success(let data):
                guard let pokemonCardsData = data as? PokemonCardsData else {
                    self?.delegate?.didFailWithError(message: "Failed to cast data to PokemonCardsData")
                    return
                }

                let cards = pokemonCardsData.data
                self?.pokemonCards = Dictionary(uniqueKeysWithValues: cards.map { ($0.id, $0) })
                self?.delegate?.didLoadCardsCollectionViewModel(self!)
            case .failure(let error):
                self?.delegate?.didFailWithError(message: error.localizedDescription)
                return
            }
        }
    }

    func configure(forSetID setID: String) {
        self.setID = setID
    }

}
extension CardsCollectionViewModel {

    private func processUserSetsResults(withRepositoryResult result: Result<Any, URLError> ) {
        switch result {
        case .success(let userCardsData):
            guard let userCardsData = userCardsData as? FirebaseData<FirebaseUserCards> else {
                self.delegate?.didFailWithError(message: "Failed to cast data to userCardsData")
                return
            }
            self.userPokemonCards.removeAll()
            let models = userCardsData.data

            userPokemonCards = Dictionary(uniqueKeysWithValues: models.map { ($0.id, $0) })
            self.delegate?.didLoadCardsCollectionViewModel(self)
        case .failure(let error):
            self.delegate?.didFailWithError(message: error.localizedDescription)
        }
    }

}
