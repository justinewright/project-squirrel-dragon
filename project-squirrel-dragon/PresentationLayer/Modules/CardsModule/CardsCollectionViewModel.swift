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
    private var pokemonCardsRepository: TCGCardsRepositoryProtocol
    private var userCardsRepository: RepositoryProtocol

    // MARK: - Other Properties
    private(set) var pokemonCards: [String: PokemonTCGCards] = [:]
    private(set) var userPokemonCards: [String: FirebaseUserCards] = [:]
    private var setID: String!
    private (set) cardsOrganiser: CardsOrganiser!
    var collectableCards: [CollectableCard] {
        pokemonCards.map { CollectableCard.init(id: $0.key,
                                                pokemonCard: $0.value,
                                                userCard: userPokemonCards[$0.key]) }
    }

    // MARK: - Initialization
    init(delegate: CardsCollectionViewModelDelegate,
         pokemonCardsRepository: TCGCardsRepositoryProtocol,
         userCardsRepository: RepositoryProtocol) {
        self.delegate = delegate
        self.pokemonCardsRepository = pokemonCardsRepository
        self.userCardsRepository = userCardsRepository
    }

    func fetchViewData() {
        guard let setID = setID else { return }
        pokemonCardsRepository.fetch(itemWithID: setID) { [weak self] result in
            switch result {
            case .success(let data):
                guard let pokemonCardsData = data as? PokemonCardsData else {
                    self?.delegate?.didFailWithError(message: "Failed to cast data to PokemonCardsData")
                    return
                }

                let cards = pokemonCardsData.data
                let unsortedDictionary = Dictionary(uniqueKeysWithValues: cards.map { ($0.id, $0) })
                let sortedDictionary = [String: PokemonTCGCards](uniqueKeysWithValues: unsortedDictionary.sorted{ $0.value.nationalPokedexNumbers.first! < $1.value.nationalPokedexNumbers.first! })
                self?.pokemonCards = sortedDictionary

                self?.userCardsRepository.fetch(itemWithID: setID) { [weak self] result in
                    self?.processUserCardsResults(withRepositoryResult: result)
                }
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

// MARK: - User Cards Repository Methods
extension CardsCollectionViewModel {

    func postCard(cardId: String, withCollectedNumber collectedNumber: Int) {
        if collectedNumber == 0 {
            removeCard(cardId: cardId)
            return
        }
        let userCard = UserCardData(id: cardId, collectedNumber: collectedNumber).toAnyObject()

        userCardsRepository.post(userCard, withPostId: cardId) { [weak self] result in
            self?.processUserCardsResults(withRepositoryResult: result)
        }
    }

    func removeCard(cardId: String) {
        userCardsRepository.delete(cardId) { [weak self] result in
            self?.processUserCardsResults(withRepositoryResult: result)
        }
    }

    private func processUserCardsResults(withRepositoryResult result: Result<Any, URLError> ) {
        switch result {
        case .success(let userData):
            guard let userCardsData = userData as? FirebaseData<FirebaseUserCards> else {
                self.delegate?.didFailWithError(message: "Failed to cast data to UserSetData")
                return
            }
            self.userPokemonCards.removeAll()

            userPokemonCards = Dictionary(uniqueKeysWithValues: userCardsData.data.map { ($0.id, $0) })
            cardsOrganiser = CardsOrganiser(collectableCards: collectableCards)
            self.delegate?.didLoadCardsCollectionViewModel(self)
        case .failure(let error):
            self.delegate?.didFailWithError(message: error.localizedDescription)
        }
    }
}


