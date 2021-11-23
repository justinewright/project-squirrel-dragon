//
//  UserSet.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/20.
//

import Foundation
import Firebase

struct FirebaseData<T:Codable>: Codable {
    let id: String
    let data: [T]

    enum CodingKeys: String, CodingKey {
            case data
            case id
        }
}

struct UserSetData: Codable {
    let id: String
    let collectedCards: Int
//    var cardData: [FirebaseCollectedCardData] = []

    init(id: String, collectedCards: Int) {
        self.id = id
        self.collectedCards = collectedCards
//        self.cardData = cardData
    }

    init(userSet: UserSet) {
        self.id = userSet.id
        self.collectedCards = userSet.cardsCollected
//        self.cardData = []
    }

    func toAnyObject() -> Any {
        return [
            "id": id,
            "collectedCards": collectedCards
//            "cardData": cardData
        ]
    }

    enum CodingKeys: String, CodingKey {
            case id = "id"
            case collectedCards = "collectedCards"
//            case cardData = "cardData"
        }
}

struct FirebaseCollectedCardData: Codable {
    let rarity: String
    let collectedAmount: Int

    func toAnyObject() -> Any {
            return [
                "rarity": rarity,
                "collectedAmount": collectedAmount
            ]
    }
    
    enum CodingKeys: String, CodingKey {
            case rarity = "rarity"
            case collectedAmount = "collectedAmount"
        }
}
