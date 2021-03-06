//
//  PokemonCardsData.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/10.
//

import Foundation

struct PokemonCardsData: Codable {
    let data: [CardData]
}

struct CardData: Codable {
    let id: String
    let name: String
    let supertype: String?
    let subtypes: [String]?
    let level: String?
    let hp: String?
    let types: [String]?
    let evolvesFrom: String?
    let abilities: [Abilities]?
    let attacks: [Attacks]?
    let weaknesses: [Weaknesses]?
    let retreatCost: [String]?
    let convertedRetreatCost: Int?
    let set: SetsData
    let number: String
    let artist: String
    let rarity: String?
    let flavorText: String?
    let nationalPokedexNumbers: [Int]?
    let images: CardImages
    let cardmarket: CardMarket

    var pricesDictionary: [String: Double?] {
        ["averageSellPrice": cardmarket.prices.averageSellPrice,
        "lowPrice": cardmarket.prices.lowPrice,
        "trendPrice": cardmarket.prices.trendPrice,
        "germanProLow": cardmarket.prices.germanProLow,
        "reverseHoloSell": cardmarket.prices.reverseHoloSell,
        "reverseHoloLow": cardmarket.prices.reverseHoloLow,
        "reverseHoloTrend": cardmarket.prices.reverseHoloTrend,
        "lowPriceExPlus": cardmarket.prices.lowPriceExPlus,
        "avg1": cardmarket.prices.avg1,
        "avg7": cardmarket.prices.avg7,
        "avg30": cardmarket.prices.avg30,
        "reverseHoloAvg1": cardmarket.prices.reverseHoloAvg1,
        "reverseHoloAvg7": cardmarket.prices.reverseHoloAvg7,
        "reverseHoloAvg30": cardmarket.prices.reverseHoloAvg30]
    }
}

struct Abilities: Codable {
    let name: String?
    let text: String?
    let type: String?
}

struct Attacks: Codable {
    let name: String?
    let cost: [String]?
    let convertedEnergyCost: Int?
    let damage: String?
    let text: String?
}

struct Weaknesses: Codable {
    let type: String?
    let value: String?
}

struct CardImages: Codable {
    let small: String
    let large: String
}

struct CardMarket: Codable {
    let url: String
    let updatedAt: String
    let prices: Prices
}

struct Prices: Codable {
    let averageSellPrice: Double?
    let lowPrice: Double?
    let trendPrice: Double?
    let germanProLow: Double?
    let suggestedPrice: Double?
    let reverseHoloSell: Double?
    let reverseHoloLow: Double?
    let reverseHoloTrend: Double?
    let lowPriceExPlus: Double?
    let avg1: Double?
    let avg7: Double?
    let avg30: Double?
    let reverseHoloAvg1: Double?
    let reverseHoloAvg7: Double?
    let reverseHoloAvg30: Double?
}

let RarityImageNames = [
    "Common" : "circle.fill",
    "Uncommon" : "diamond.fill",
    "Rare" : "star.fill",
    "Promo": "seal.fill"
    ]
