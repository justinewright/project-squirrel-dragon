//
//  SelectMenuViewController.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/28.
//

import UIKit

class SelectMenuViewController: UIViewController {

    @IBOutlet private weak var dismissableKeyboardView: UIView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var filterLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!

    private var addSet: [String] = []
    private var removeSet: [String] = []
    var originalList: [SelectableSet] = []

    var callback: ((_ newSelectedSets: [String]?, _ deselectedSets: [String]?) -> Void)?

    @IBAction func doneButtonPushed(_ sender: UIButton) {
        callback?(addSet, removeSet)
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        callback?(nil, nil)
    }

    override func viewDidLoad() {

    }

}

extension SelectMenuViewController: UISearchBarDelegate {

}

extension SelectMenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

}

extension SelectMenuViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        originalList[indexPath.row].selected = !originalList[indexPath.row].selected
    }
}
