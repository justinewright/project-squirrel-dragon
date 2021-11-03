//
//  UserSet.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/20.
//

import Foundation
import Firebase
struct UserSet {
    var id: String = ""
    var cardsCollected: Int = -1

    init(snapshot: DataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: AnyObject],
              let id = snapshotValue["id"] as? String,
              let cardsCollected = snapshotValue["collectedCards"] as? Int else {
                  return
              }

        self.id = id
        self.cardsCollected = cardsCollected
       }

    init(userSetData: UserSetData) {
        id = userSetData.id
        cardsCollected = userSetData.collectedCards
    }
}
