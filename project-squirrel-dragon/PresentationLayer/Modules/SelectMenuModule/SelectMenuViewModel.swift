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

    // MARK: - Computed Variables
    var removedChanges: Int {differenceList[.removed]?.count ?? 0}
    var addedChanges: Int {differenceList[.added]?.count ?? 0}
    var totalChanges: Int {removedChanges + addedChanges}

    // MARK: - Filter Properties
    var filteredList: [String] = []
    var sets: [String: SelectableSet] {
        filteredList.isEmpty ? originalList :
        originalList.filter{ filteredList.description.lastSubString.contains($0.key) }
    }

    // MARK: - Initialization
    init(withDelegate delegate: SelectMenuViewModelDelegate? = nil) {
        self.delegate = delegate
    }

    func setList(withNewList list: [SelectableSet]) {
        originalList = Dictionary(uniqueKeysWithValues: list.map({($0.id, $0)}))
        delegate?.refreshView()
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
        delegate?.refreshView()
    }

    var searchList: [String] {
        originalList.map { $0.value.description }
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
