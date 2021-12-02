//
//  WatchStatsViewModel.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/30.
//

import Foundation

protocol WatchStatsViewModelDelegate: AnyObject {
    func didLoadWatchStatsViewModel(_ watchStatsViewModel: WatchStatsViewModel)
    func didFailWithError(message: String)
}

class WatchStatsViewModel {
    typealias PokemonTCGCards = CardData
    typealias FirebaseUserCards = UserCardData
    typealias FirebaseUserSets = UserSetData

    // MARK: - Properties
    private weak var delegate: WatchStatsViewModelDelegate?
    private var pokemonCardsRepository: TCGCardsRepositoryProtocol
    private var userCardsRepository: RepositoryProtocol
    private var userSetRepository: RepositoryProtocol

    // MARK: - Other Properties
    // TODO: - save rarity progress on firebase
    private(set) var pokemonSetCards: [String:[String: PokemonTCGCards]] = [:]
    private(set) var userPokemonCards: [String: FirebaseUserCards] = [:]
    private(set) var setCollectableCards: [String: CardsOrganiser] = [:]

    // MARK: - Initialization
    init(delegate: WatchStatsViewModelDelegate,
         pokemonCardsRepository: TCGCardsRepositoryProtocol,
         userCardsRepository: RepositoryProtocol,
         userSetRepository: RepositoryProtocol) {
        self.delegate = delegate
        self.pokemonCardsRepository = pokemonCardsRepository
        self.userCardsRepository = userCardsRepository
        self.userSetRepository = userSetRepository
    }

    func fetchViewData() {
        //1. fetch user sets
        userSetRepository.fetch { [weak self] result in
            switch result {
            case .success(let userData):
                guard let userSetsData = userData as? FirebaseData<FirebaseUserSets> else {
                    self?.delegate?.didFailWithError(message: "Failed to cast data to UserSetData")
                    return
                }
                userSetsData.data.forEach { self?.fetchSetCards(forSetId: $0.id) }

                return
            case .failure(let error):
                self?.delegate?.didFailWithError(message: error.localizedDescription)
                return
            }
        }
    }

    fileprivate func fetchSetCards(forSetId setId: String) {
        //2. fetch cards for user sets
        pokemonCardsRepository.fetch(itemWithID:  "set.id:\(setId)") { [weak self] result in
            switch result {
            case .success(let data):
                guard let pokemonCardsData = data as? PokemonCardsData else {
                    self?.delegate?.didFailWithError(message: "Failed to cast data to PokemonCardsData")
                    return
                }

                let cards = pokemonCardsData.data
                self?.pokemonSetCards[setId] = Dictionary(uniqueKeysWithValues: cards.map { ($0.id, $0) })

                self?.fetchUserCards()
            case .failure(let error):
                self?.delegate?.didFailWithError(message: error.localizedDescription)
                return
            }

        }
    }

    fileprivate func updatePokemonCards(_ userCardsData: FirebaseData<CardsCollectionViewModel.FirebaseUserCards>) {
        self.userPokemonCards.removeAll()
        userPokemonCards = Dictionary(uniqueKeysWithValues: userCardsData.data.map { ($0.id, $0) })
    }

    fileprivate func fetchUserCards() {
        //3. fetch user cards for user sets
        userCardsRepository.fetch() { [weak self] result in
            self?.processUserCardsResults(withRepositoryResult: result)
        }
    }

    private func processUserCardsResults(withRepositoryResult result: Result<Any, URLError> ) {
        //4. update information
        switch result {
        case .success(let userData):
            guard let userCardsData = userData as? FirebaseData<FirebaseUserCards> else {
                self.delegate?.didFailWithError(message: "Failed to cast data to UserSetData")
                return
            }
            self.updatePokemonCards(userCardsData)
            self.updateCardOrganiser()
            self.delegate?.didLoadWatchStatsViewModel(self)
        case .failure(let error):
            self.delegate?.didFailWithError(message: error.localizedDescription)
        }
    }

    fileprivate func updateCardOrganiser() {
        pokemonSetCards.forEach { setId, pokemonCards in
            let collectableCards = pokemonCards.map { CollectableCard.init(id: $0.key,
                                                    pokemonCard: $0.value,
                                                    userCard: userPokemonCards[$0.key]) }
            setCollectableCards[setId] = CardsOrganiser(collectableCards: collectableCards)
        }
    }

    var collectedCardsStats: Any {
        CollectedCardsStats(commonCardsPercentage: collectedCardsPercentage(forRarity: .common),
                            uncommonCardsPercentage: collectedCardsPercentage(forRarity: .uncommon),
                            rareCardsPercentage: collectedCardsPercentage(forRarity: .rare),
                            promoCardsPercentage: collectedCardsPercentage(forRarity: .promo),
                            totalPercentage: totalCollectedCardsPercentage()).toAnyObject()
    }

    private func collectedCardsPercentage(forRarity rarity: CardsOrganiser.CardRarity) -> Int {
        var totalCards = 1
        var collectedCards = 0
        setCollectableCards.forEach { key, value in
            totalCards += value.dividedTotalCardsByRarityCount[rarity] ?? 0
            collectedCards += setCollectableCards[key]?.numberOfCollectedCards(ofRarity: rarity) ?? 0
        }
        return Int(Double(collectedCards) / Double(totalCards) * 100)
    }

    private func totalCollectedCardsPercentage() -> Int {
        var totalCards = 1
        var collectedCards = 0
        setCollectableCards.forEach { key, value in
            totalCards += setCollectableCards[key]?.totalCards ?? 0
            collectedCards += setCollectableCards[key]?.totalCollectedCards ?? 0
        }
        return Int(Double(collectedCards) / Double(totalCards) * 100)
    }

}
