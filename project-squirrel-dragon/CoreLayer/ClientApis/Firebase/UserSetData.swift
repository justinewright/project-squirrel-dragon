//
//  UserSet.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/20.
//

import Foundation

struct UserSetData: Codable {
    let id: String
    let collectedCards: Int
    let cardData: [FirebaseCollectedCardData]

    init(id: String, collectedCards: Int, cardData: [FirebaseCollectedCardData]) {
        self.id = id
        self.collectedCards = collectedCards
        self.cardData = cardData
    }

    init(userSet: UserSet){
        self.id = userSet.id
        self.collectedCards = userSet.cardsCollected
        self.cardData = []
    }

    func toAnyObject() -> Any {
        return [
            "id" : id,
            "collectedCards" : collectedCards,
            "cardData": [cardData]
        ]

    }
}

struct FirebaseCollectedCardData: Codable {
    let rarity: String
    let collectedAmount: Int

    var dictionary: [String: Any] {
        return [
            "rarity" : rarity,
            "collectedAmount" : collectedAmount
        ]
    }
    func toAnyObject() -> Any {
            return [
                "rarity": rarity,
                "collectedAmount": collectedAmount
            ]
    }
}
