//
//  SelectMenuViewController.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/28.
//

import UIKit

class SelectMenuViewController: UIViewController {


    // MARK: - PROPERTIES
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    private lazy var searchBarViewController = UIViewController()
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

    // MARK: - LifecycleMethods
    override func viewDidLoad() {
        configureCollectionView()
    }
    
    func setList(withNewList list: [SelectableSet]) {
        viewModel.setList(withNewList: list)
    }

    func setSearchList(withSearchList list: [String]) {
        viewModel.setSearchList(withSearchList: list)
        configureSearchView()
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

    fileprivate func constrainSearchBar() {
        searchBarViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBarViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            searchBarViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchBarViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureSearchView() {

        searchBarViewController = CustomSearchBarModuleBuilder.build()
        guard let configuredSearchBar = searchBarViewController as? CustomSearchBarViewController else {
            return
        }
        if let searchBarViewModel = CustomSearchBarViewModel(list: viewModel.searchList,
                                                             andDelegate: self) {
            configuredSearchBar.configure(searchBarViewModel, withAddButton: false)
            addChild(searchBarViewController)
            view.addSubview(searchBarViewController.view)
            searchBarViewController.didMove(toParent: self)
            constrainSearchBar()
        }
    }

}

extension SelectMenuViewController: UISearchBarDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let configuredSearchBar = searchBarViewController as? CustomSearchBarViewController else{
            return
        }
        var actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        configuredSearchBar.handleScroll(&actualPosition)
    }
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
        let animation = AnimationFactory.makeFadeAnimation(duration: 0.5, delayFactor: 0.05)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: collectionView)
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

extension SelectMenuViewController: CustomSearchbarViewModelDelegate {
    func updateDisplay(_ sender: CustomSearchBarViewModel!, withSearchFilter searchFilter: String!) {
        viewModel.filteredList = sender.filteredList as? [String] ?? [String]()
        self.collectionView.reloadData()
    }

    func showSelectMenu(_ sender: CustomSearchBarViewModel!) {

    }
}
