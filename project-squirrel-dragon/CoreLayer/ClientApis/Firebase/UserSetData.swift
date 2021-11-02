//
//  UserSet.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/20.
//

import Foundation

struct UserSetData: Codable {
    var id: String
    let setData: FirebaseSetsData
    let cardData: [FirebaseCollectedCardData]
}

struct FirebaseSetsData: Codable {
    let id: String
    let collectedCards: Int
}

struct FirebaseCollectedCardData: Codable {
    let rarity: String
    let collectedAmount: Int
}
