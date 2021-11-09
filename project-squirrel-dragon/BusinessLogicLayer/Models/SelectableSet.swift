//
//  SetSelectionTracker.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/28.
//

import Foundation

struct SelectableSet {
    let id: String
    let labelText: String
    let imageUrl: String
    var selected: Bool

    init (id: String, series: String, url: String, selected: Bool) {
        self.id = id
        self.labelText = series
        self.imageUrl = url
        self.selected = selected
    }
}
