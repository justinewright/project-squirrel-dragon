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
    let supertype: String
    let subtypes: [String]
    let level: Int
    let hp: Int
    let types: [String]
    let evolvesFrom: String
    let abilities: [Abilities]
    let attacks: [Attacks]
    let weaknesses: [Weaknesses]
    let retreatCost: [String]
    let convertedRetreatCost: Int
    let set: SetsData
    let number: Int
    let artist: String
    let rarity: String
    let flavorText: String
    let nationalPokedexNumbers: [Int]
    let images: CardImages
    let cardmarket: CardMarket
}

struct Abilities: Codable {
    let name: String
    let text: String
    let type: String

}

struct Attacks: Codable {
    let name: String
    let cost: [String]
    let convertedEnergyCost: Int
    let damage: String
    let text: String
}

struct Weaknesses: Codable {
    let type: String
    let value: String
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
    let averageSellPrice: Double
    let lowPrice: Double
    let trendPrice: Double
    let germanProLow: Double
    let suggestedPrice: Double
    let reverseHoloSell: Double
    let reverseHoloLow: Double
    let reverseHoloTrend: Double
    let lowPriceExPlus: Double
    let avg1: Double
    let avg7: Double
    let avg30: Double
    let reverseHoloAvg1: Double
    let reverseHoloAvg7: Double
    let reverseHoloAvg30: Double
}

let RarityImageNames = [
    "Common" : "circle.fill",
    "Uncommon" : "diamond.fill",
    "Rare" : "star.fill",
    "Promo": "seal.fill"
    ]
