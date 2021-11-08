//
//  PokemonCollectionSetsViewController.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/07.
//

import UIKit

class PokemonCollectionSetsViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var pokemonCollectionSetsCollectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var promptLabel: UILabel!
//    var a = TCGPokemonRepository(apiClient: PokemonTcgApiClient<PokemonSetsData.self>)
    private lazy var viewModel = PokemonCollectionSetsViewModel(pokemonCollectionViewModelDelegate: self,
                                                                pokemonSetsRepository: TCGPokemonRepository<PokemonSetsData>(apiClient: PokemonTcgApiClient<PokemonSetsData>(endPoint: Endpoint(path: "sets"))), userSetsRepository: UserPokemonSetsRepository<UserSetData>())

    private let cellReuseIdentifier = "PokemonCollectionSetCell"
    private let cellNibName = "PokemonCollectionSetCell"
    private var searchBarViewController = UIViewController()
    private let errorTitle = "Pokemon Sets Unavailable!"

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        configureCollectionView()
        viewModel.fetchViewData()
        activityIndicator.startAnimating()
        promptLabel.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    private func configureCollectionView() {
        pokemonCollectionSetsCollectionView.dataSource = self
        pokemonCollectionSetsCollectionView.delegate = self
        pokemonCollectionSetsCollectionView.register(PokemonCollectionSetCell.self,
                                     forCellWithReuseIdentifier: cellReuseIdentifier)
        pokemonCollectionSetsCollectionView.register(UINib(nibName: cellNibName, bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        pokemonCollectionSetsCollectionView.backgroundColor = .clear
    }

    fileprivate func constrainSearchBar() {
        searchBarViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBarViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            searchBarViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchBarViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureSearchView() {
        searchBarViewController.willMove(toParent: nil)
        searchBarViewController.view.removeFromSuperview()
        searchBarViewController.removeFromParent()

        searchBarViewController = CustomSearchBarModuleBuilder.build()
        guard let configuredSearchBar = searchBarViewController as? CustomSearchBarViewController else {
            return
        }
        if let searchBarViewModel = CustomSearchBarViewModel(list: viewModel.userSearchList,
                                                             andDelegate: self) {
            configuredSearchBar.configure(searchBarViewModel, withAddButton: true)
            addChild(searchBarViewController)
            view.addSubview(searchBarViewController.view)
            searchBarViewController.didMove(toParent: self)
            constrainSearchBar()
        }
    }
}

// MARK: - Collection Delegate Methods
extension PokemonCollectionSetsViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let configuredSearchBar = searchBarViewController as? CustomSearchBarViewController else{
            return
        }
        var actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        configuredSearchBar.handleScroll(&actualPosition)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let destination = SetDetailsModuleBuilder.build(usingNavigationFactory: NavigationBuilder.build, andPokemonSet: viewModel.sets[viewModel.keys[indexPath.row]]!)
        self.navigationController?.pushViewController(destination, animated: true)
    }
}

// MARK: - ViewModel Delegate Methods
extension PokemonCollectionSetsViewController: PokemonCollectionViewModelDelegate {

    func didLoadPokemonCollectionSetsViewModel(_ pokemonCollectionSetsViewModel: PokemonCollectionSetsViewModel) {
        self.pokemonCollectionSetsCollectionView.isHidden = false
        self.pokemonCollectionSetsCollectionView.reloadData()
        self.configureSearchView()
        activityIndicator.stopAnimating()
        promptLabel.isHidden = !viewModel.userPokemonCollectionSets.isEmpty
    }

    func didFailWithError(message: String) {
        self.showErrorAlert(titled: errorTitle, with: message)
        activityIndicator.stopAnimating()
    }
}

// MARK: - CollectionView DataSource Methods
extension PokemonCollectionSetsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? PokemonCollectionSetCell,
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

// MARK: - SearchBar Delegate Methods

extension PokemonCollectionSetsViewController:  CustomSearchbarViewModelDelegate {
    func showSelectMenu(_ sender: CustomSearchBarViewModel!) {
        self.showSelectAlert(titled: "'Squirrel Dragon' would like to update your sets ", with: "", handler: handleSelectMenu)
    }

    fileprivate func onRefreshView() {
        self.pokemonCollectionSetsCollectionView.isHidden = true
        self.activityIndicator.startAnimating()
        self.promptLabel.isHidden = !self.viewModel.userPokemonCollectionSets.isEmpty
    }

    fileprivate func processSetDifferences(_ addedSets: [String]?, _ removedSets: [String]?) {
        if (addedSets == nil && removedSets == nil) || (addedSets?.isEmpty ?? true && removedSets?.isEmpty ?? true) {
            return
        }

        self.onRefreshView()
        if let addedSets = addedSets {
            self.viewModel.addSet(setIDs: addedSets)
        }
        if let removedSets = removedSets {
            self.viewModel.removeSet(setIDs: removedSets)
        }
    }

    private func handleSelectMenu(action: UIAlertAction! = nil) {
        let navVC = SelectMenuModuleBuilder.build(usingNavigationFactory: NavigationBuilder.build, andViewModel: viewModel)
        guard let destination = navVC.children.first as? SelectMenuViewController else {
            return
        }

        self.present(navVC, animated: true, completion: nil)
        destination.callback = { (addedSets, removedSets) -> Void in
            navVC.dismiss(animated: true)
            self.processSetDifferences(addedSets, removedSets)
        }
    }

    func updateDisplay(_ sender: CustomSearchBarViewModel!, withSearchFilter searchFilter: String!) {
        viewModel.filteredList = sender.filteredList as? [String] ?? [String]()
        self.pokemonCollectionSetsCollectionView.reloadData()
    }
}

@objc

class IgnoreTouchView : UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            return nil
        }
        return hitView
    }
}
