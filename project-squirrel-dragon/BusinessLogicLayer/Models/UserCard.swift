//
//  UserCard.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/10.
//

import Foundation

struct UserCard {
    var id: String = ""
    var collectedNumber: Int = 0
    var rarity: String

    init(userCardData: UserCardData) {
        id = userCardData.id
        collectedNumber = userCardData.collectedNumber
        rarity = userCardData.rarity
    }
}

