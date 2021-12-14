//
//  UserDefaults+Extension.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/12/13.
//

import Foundation

extension UserDefaults {
    @objc var currency: String {
        get {
            return string(forKey: "currency") ?? "EUR"
        }
        set {
            set(newValue, forKey: "currency")
        }
    }

    @objc var currencyMultiplier: Double {
        get {
            return Double("currencyMultiplier") ?? 1
        }
        set {
            set(newValue, forKey: "currencyMultiplier")
        }
    }
}
