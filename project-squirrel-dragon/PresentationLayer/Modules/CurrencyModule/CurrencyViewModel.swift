//
//  CurrencyViewModel.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/12/14.
//

import Foundation

class CurrencyViewModel {
    private(set) var filteredList: [String] = []

    init() {
        filteredList = Array(currencyList)
    }

    func filter(withSearchText searchText: String) {
        if searchText.isEmpty {
            filteredList = Array(currencyList)
        }
        filteredList = currencyList.filter({ currency in
            currency.contains(searchText.uppercased())
        })
    }

}
