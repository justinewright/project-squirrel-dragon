//
//  UserSet.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/20.
//

import Foundation

struct UserSetData: Codable {
    let id: String
    let setData: [FirebaseSetsData]
    let cardData: [FirebaseCardsData]
}

struct FirebaseSetsData: Codable {
    let id: String
    let collectedCards: Int
}

struct FirebaseCardsData: Codable {
    let setID: String
    let cardID: String
    let numberCollected: Int
    let collectedCardData: [FirebaseCollectedCardData]
}

struct FirebaseCollectedCardData: Codable {
    let rarity: String
    let collectedAmount: Int
}
