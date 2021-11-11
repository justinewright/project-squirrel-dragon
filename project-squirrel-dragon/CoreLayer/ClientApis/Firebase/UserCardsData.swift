//
//  UserCardsData.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/10.
//

import Foundation

struct UserCardData: Codable {
    let id: String
    let collectedNumber: Int
    var rarity: String

    init(id: String, collectedNumber: Int, rarity: String) {
        self.id = id
        self.collectedNumber = collectedNumber
        self.rarity = rarity
    }

    init(userCard: UserCard) {
        self.id = userCard.id
        self.collectedNumber = userCard.collectedNumber
        self.rarity = userCard.rarity
    }

    func toAnyObject() -> Any {
        return [
            "id" : id,
            "collectedNumber" : collectedNumber,
            "rarity": rarity
        ]
    }

    enum CodingKeys: String, CodingKey {
            case id
            case collectedNumber
            case rarity 
        }
}
