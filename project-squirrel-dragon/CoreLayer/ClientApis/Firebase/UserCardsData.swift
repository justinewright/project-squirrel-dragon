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

    init(id: String, collectedNumber: Int) {
        self.id = id
        self.collectedNumber = collectedNumber
    }

    init(userCard: UserCard) {
        self.id = userCard.id
        self.collectedNumber = userCard.collectedNumber
    }

    func toAnyObject() -> Any {
        return [
            "id" : id,
            "collectedNumber" : collectedNumber
        ]
    }

    enum CodingKeys: String, CodingKey {
            case id
            case collectedNumber
        }
}
