//
//  CardsDetailViewModel.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/15.
//

import Foundation

class CardDetailViewModel {
    private var cardsCollected: uint = 0
    private (set) var cardId: String = ""
    private (set) var collectableCard: CollectableCard!
    private var originalCollected: uint!

    public func configure(withCard card: CollectableCard) {
        collectableCard = card
        totalCardsCollected = card.userCard?.collectedNumber ?? 0
        cardId = card.id
        originalCollected = cardsCollected
    }

    public func addOneCard() {
        totalCardsCollected += 1
    }

    public func removeOneCard() {
        totalCardsCollected -= 1
    }

    var finalCardsCollected: Int? {
        return cardsCollected == originalCollected ? nil : totalCardsCollected
    }

    var totalCardsCollected: Int {
        get {
            return Int(cardsCollected)
        }

        set {
            cardsCollected = newValue < 0 ? 0 : uint(newValue)
        }
    }

    var nationalPokedexNumberLabel: String? {
        guard let number = collectableCard.pokemonCard.nationalPokedexNumbers.first else { return nil }
        return String(format: "%03d", number)
    }

    var cardImageUrl: URL? {
        URL(string: collectableCard.pokemonCard.images.large)
    }

    var number: String? {
        "number: " + collectableCard.pokemonCard.number
    }

    var pokemonName: String? {
        "name: " + collectableCard.pokemonCard.name
    }

    var rarity: String? {
        "rarity: " + (collectableCard.pokemonCard.rarity ??  "-")
    }

    var type: String? {
        "type: " +
        (collectableCard.pokemonCard.types?.joined(separator: ", ") ?? "-")
    }

    var prices: (String?, String?) {
        let dicitonary = collectableCard.pokemonCard.pricesDictionary
        var priceString = "Prices\n\n"
        var priceNumberString = "(€)\n\n"
        for (priceFor, priceValue) in dicitonary {
            guard let priceValue = priceValue else {
                continue
            }
            let formatedPrice = String(format: "%.2f", priceValue)
            priceNumberString += "\(formatedPrice)\n"
            priceString += "\(priceFor)\n"
        }
        return (priceString, priceNumberString)
    }
}
