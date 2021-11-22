//
//  CardsOrganiser.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/22.
//

import Foundation

class CardsOrganiser {

    public enum CardRarity: String, CaseIterable {
        case common = "Common"
        case uncommon = "Uncommon"
        case rare = "Rare"
        case promo = "Promo"
    }

    var collectableCards: [CollectableCard] = []
    var dividedTotalCardsByRarityCount: [CardRarity: Int] = [:]
    var dividedCollectedCardsByRarityCount: [CardRarity: Int] = [:]
    var totalCards: Int!
    var totalCollectedCards: Int!

    fileprivate func countTotalCards(_ collectableCards: [CollectableCard]) {
        dividedTotalCardsByRarityCount[.promo] = totalCards
        for rarity in CardRarity.allCases {
            dividedTotalCardsByRarityCount[rarity] = numberOfCards(ofRarity: rarity)
            dividedTotalCardsByRarityCount[.promo]! -=   dividedTotalCardsByRarityCount[rarity]!
        }
    }

    fileprivate func countTotalCollectedCards(_ collectableCards: [CollectableCard]) {
        dividedCollectedCardsByRarityCount[.promo] = totalCollectedCards
        for rarity in CardRarity.allCases {
            dividedTotalCardsByRarityCount[rarity] = numberOfCards(ofRarity: rarity)
            dividedTotalCardsByRarityCount[.promo]! -=   dividedTotalCardsByRarityCount[rarity]!
        }
    }

    init(collectableCards: [CollectableCard]) {
        self.collectableCards = collectableCards
        totalCards = collectableCards.first?.pokemonCard.set.total ?? 0
        totalCollectedCards = numberOfCollectedCards
        countTotalCards(self.collectableCards)
        countTotalCollectedCards(self.collectableCards)
    }

    var numberOfCollectedCards: Int {
        return collectableCards
            .filter { cardInUserCollection($0) }
            .count
    }

    func numberOfCards(ofRarity rarity: CardRarity) -> Int {
        if rarity == .promo { return dividedTotalCardsByRarityCount[rarity] ?? 0 }
        return collectableCards.filter { $0.pokemonCard.rarity?.contains(rarity.rawValue) ?? false }.count
    }

    func numberOfCollectedCards(ofRarity rarity: CardRarity) -> Int {
        if rarity == .promo { return dividedTotalCardsByRarityCount[rarity] ?? 0 }
        return collectableCards.filter { card in
            card.pokemonCard.rarity == rarity.rawValue &&
            card.userCard != nil
        }.count
    }

    private func cardInUserCollection(_ card: CollectableCard) -> Bool {
        return card.userCard != nil && (card.userCard?.collectedNumber ?? 0) > 0
    }

}
