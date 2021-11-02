//
//  SelectMenuViewController.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/28.
//

import UIKit

class SelectMenuViewController: UIViewController {
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    private let cellReuseIdentifier = "SelectableSetCell"
    private let cellNibName = "SelectableSetCell"
    private lazy var viewModel = SelectMenuViewModel(withDelegate: self)
    var callback: ((_ newSelectedSets: [String]?, _ deselectedSets: [String]?) -> Void)?

    @IBAction func doneButtonPushed(_ sender: UIButton) {
        callback?(viewModel.addedSets, viewModel.removedSets)
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        callback?(nil, nil)
    }

    override func viewDidLoad() {
        configureCollectionView()
    }
    
    func setList(withNewList list: [SelectableSet]){
        viewModel.setList(withNewList: list)
    }

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PokemonCollectionSetCell.self,
                                     forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.register(UINib(nibName: cellNibName, bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
    }

}

extension SelectMenuViewController: UISearchBarDelegate {

}

extension SelectMenuViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? SelectableSetCell,
              let cellData = viewModel.sets[viewModel.keys[indexPath.row]] else {
            return UICollectionViewCell()
        }
        cell.configure(with: cellData)
        return cell
    }

}

extension SelectMenuViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectableSetCell,
        let setID = cell.selectableSet?.id else { return }

        viewModel.toggleItem(withId: setID)
    }
}

extension SelectMenuViewController: SelectMenuViewModelDelegate {
        func refreshView() {
            collectionView.reloadData()
        }
}
