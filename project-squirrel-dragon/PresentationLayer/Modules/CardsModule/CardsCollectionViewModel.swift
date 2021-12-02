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
    private var userSetRepository: RepositoryProtocol

    // MARK: - Other Properties
    private(set) var pokemonCards: [String: PokemonTCGCards] = [:]
    private(set) var userPokemonCards: [String: FirebaseUserCards] = [:]
    private var setID: String!
    private (set) var cardsOrganiser: CardsOrganiser!

    var collectableCards: [CollectableCard] {
        var collectableCards = pokemonCards.map { CollectableCard.init(id: $0.key,
                                                pokemonCard: $0.value,
                                                userCard: userPokemonCards[$0.key]) }
        collectableCards = collectableCards.sorted{ $0.pokemonCard.nationalPokedexNumbers?.first! ?? 9999 < $1.pokemonCard.nationalPokedexNumbers?.first! ?? 9999}
        return collectableCards
    }

    // MARK: - Initialization
    init(delegate: CardsCollectionViewModelDelegate,
         pokemonCardsRepository: TCGCardsRepositoryProtocol,
         userCardsRepository: RepositoryProtocol,
         userSetRepository: RepositoryProtocol) {
        self.delegate = delegate
        self.pokemonCardsRepository = pokemonCardsRepository
        self.userCardsRepository = userCardsRepository
        self.userSetRepository = userSetRepository
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
                self?.pokemonCards = Dictionary(uniqueKeysWithValues: cards.map { ($0.id, $0) })

                self?.userCardsRepository.fetch { [weak self] result in
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
                self.delegate?.didFailWithError(message: "Failed to cast data to UserCardData")
                return
            }
            self.updatePokemonCards(userCardsData)
            self.updateCardOrganiser()
            self.delegate?.didLoadCardsCollectionViewModel(self)
            updateUserSet()
        case .failure(let error):
            self.delegate?.didFailWithError(message: error.localizedDescription)
        }
    }

    fileprivate func updatePokemonCards(_ userCardsData: FirebaseData<CardsCollectionViewModel.FirebaseUserCards>) {
        self.userPokemonCards.removeAll()
        userPokemonCards = Dictionary(uniqueKeysWithValues: userCardsData.data.map { ($0.id, $0) })
    }

    fileprivate func updateCardOrganiser() {
        cardsOrganiser = CardsOrganiser(collectableCards: collectableCards)
    }
}

// MARK: - User Set Methods
private extension CardsCollectionViewModel {
    func updateUserSet() {
        let processedID = String(setID.split(separator: ":").last!)
        userSetRepository.post(UserSetData(id: processedID,
                                           collectedCards: cardsOrganiser.numberOfCollectedCards).toAnyObject(),
                               withPostId: processedID) { [weak self] result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                self?.delegate?.didFailWithError(message: error.localizedDescription)
            }
        }
    }
}

// MARK: - Formatted Text

extension CardsCollectionViewModel {
    func progressString(forRarity rarity: CardsOrganiser.CardRarity) -> String {
        guard let collectedCount = cardsOrganiser.dividedCollectedCardsByRarityCount[rarity],
              let totalCount = cardsOrganiser.dividedTotalCardsByRarityCount[rarity] else {
            return "-/-"
        }
        return "\(collectedCount)/\(totalCount)"
    }
}
