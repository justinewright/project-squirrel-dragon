//
//  SelectMenuViewModel.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/29.
//

import Foundation

protocol SelectMenuViewModelDelegate: AnyObject {
    func refreshView()
}

class SelectMenuViewModel {
    enum Difference {
        case added
        case removed
    }
    // MARK: - Properties
    private(set) var differenceList: [Difference: [String : SelectableSet]] = [.added: [:], .removed: [:]]
    private(set) var originalList: [String: SelectableSet] = [:]
    private weak var delegate: SelectMenuViewModelDelegate?
    private (set) var searchList: [String] = []

    // MARK: - Computed Variables
    var removedChanges: Int {differenceList[.removed]?.count ?? 0}
    var addedChanges: Int {differenceList[.added]?.count ?? 0}
    var totalChanges: Int {removedChanges + addedChanges}
    var addedSets: [String]? { differenceList[.added].map{ $0.map { $0.key}}  }
    var removedSets: [String]? {differenceList[.removed].map{ $0.map { $0.key}}  }
    // MARK: - Filter Properties
    var filteredList: [String] = []
    var sets: [String: SelectableSet] {
        filteredList.isEmpty ? originalList :
        originalList.filter { filteredList.map{ $0.lastSubString }.contains($0.key) }
    }

    // MARK: - Initialization
    init(withDelegate delegate: SelectMenuViewModelDelegate? = nil) {
        self.delegate = delegate
    }

    func setList(withNewList list: [SelectableSet]) {
        originalList = Dictionary(uniqueKeysWithValues: list.map({($0.id, $0)}))
    }

    func setSearchList(withSearchList list: [String]) {
        searchList = list
    }

    func toggleItem(withId itemID: String) {
        guard let _ = originalList[itemID] else {
            return
        }
        if isItemOriginal(itemID) {
            toggleOriginalItem(itemID)
        } else {
            toggleModifiedItem(itemID)
        }
        originalList[itemID]!.selected = !originalList[itemID]!.selected
    }

    var keys: [String] {
        Array(sets.keys)
    }

    // MARK: - Private methods
    fileprivate func toggleOriginalItem(_ itemID: String) {
        let targetKey: Difference = originalList[itemID]!.selected ? .removed : .added
        differenceList[targetKey]![itemID] = originalList[itemID]!
    }

    fileprivate func toggleModifiedItem(_ itemID: String) {
        let targetKey: Difference = originalList[itemID]!.selected ? .added : .removed
        differenceList[targetKey]!.removeValue(forKey: itemID)
    }

    private func isItemOriginal(_ itemID: String) -> Bool {
        differenceList[.added]![itemID] == nil && differenceList[.removed]![itemID] == nil
    }

}
