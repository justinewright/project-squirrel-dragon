//
//  UserSet.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/20.
//

import Foundation

struct UserSet {
    var id: String = ""
    var cardsCollected: Int = -1

    init(userSetData: UserSetData) {
        id = userSetData.id
        cardsCollected = userSetData.collectedCards
    }
}
