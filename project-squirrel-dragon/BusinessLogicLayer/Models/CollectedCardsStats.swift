//
//  CollectedCardsStats.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/30.
//

import Foundation

struct CollectedCardsStats {
    let commonCardsPercentage: Int
    let uncommonCardsPercentage: Int
    let rareCardsPercentage: Int
    let promoCardsPercentage: Int
    let totalPercentage: Int

    init(commonCardsPercentage: Int,
         uncommonCardsPercentage: Int,
         rareCardsPercentage: Int,
         promoCardsPercentage: Int,
         totalPercentage: Int) {
        self.commonCardsPercentage = commonCardsPercentage
        self.uncommonCardsPercentage = uncommonCardsPercentage
        self.rareCardsPercentage = rareCardsPercentage
        self.promoCardsPercentage = promoCardsPercentage
        self.totalPercentage = totalPercentage
    }

    init(dictionary: [String: Any]) {
        self.commonCardsPercentage = dictionary["commonCardsPercentage"] as? Int ?? 0
        self.uncommonCardsPercentage = dictionary["uncommonCardsPercentage"] as? Int ?? 0
        self.rareCardsPercentage = dictionary["rareCardsPercentage"] as? Int ?? 0
        self.promoCardsPercentage = dictionary["promoCardsPercentage"] as? Int ?? 0
        self.totalPercentage = dictionary["totalPercentage"] as? Int ?? 0
        }

    func toAnyObject() -> Any {
        return [
          "commonCardsPercentage": commonCardsPercentage,
          "uncommonCardsPercentage": uncommonCardsPercentage,
          "rareCardsPercentage": rareCardsPercentage,
          "promoCardsPercentage": promoCardsPercentage,
          "totalPercentage": totalPercentage
        ]
    }
}
