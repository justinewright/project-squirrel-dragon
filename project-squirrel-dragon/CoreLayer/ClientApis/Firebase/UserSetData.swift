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

    init(id: String, collectedCards: Int) {
        self.id = id
        self.collectedCards = collectedCards
    }

    init(userSet: UserSet) {
        self.id = userSet.id
        self.collectedCards = userSet.cardsCollected
    }

    func toAnyObject() -> Any {
        return [
            "id": id,
            "collectedCards": collectedCards
        ]
    }

    enum CodingKeys: String, CodingKey {
            case id = "id"
            case collectedCards = "collectedCards"
        }
}
