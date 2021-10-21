//
//  PokemonCollectionSetsViewController.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/07.
//

import UIKit

class PokemonCollectionSetsViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var pokemonCollectionSetsCollectionView: UICollectionView!
    private lazy var viewModel = PokemonCollectionSetsViewModel(pokemonCollectionViewModelDelegate: self, repository: PokemonCollectionSetsRepository())
    private let cellReuseIdentifier = "PokemonCollectionSetCell"
    private let cellNibName = "PokemonCollectionSetCell"
    private var searchBarViewController = UIViewController()
    private var filteredNames: [String] = []

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        configureCollectionView()
        viewModel.updateView()
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

    private func configureSearchView() {
        searchBarViewController = CustomSearchBarModuleBuilder.build()
        addChild(searchBarViewController)
        guard let configuredSearchBar = searchBarViewController as? CustomSearchBarViewController else{
            return
        }
        if let searchBarViewModel = CustomSearchBarViewModel(list:    viewModel.pokemonCollectionSets.map { $0.value.description}, andDelegate: self) {
            configuredSearchBar.configure(searchBarViewModel)
            addChild( searchBarViewController)
            view.addSubview(searchBarViewController.view)
            
        }

    }

}
extension PokemonCollectionSetsViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let configuredSearchBar = searchBarViewController as? CustomSearchBarViewController else{
            return
        }
        var actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        configuredSearchBar.handleScroll(&actualPosition)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var pokemonSet: PokemonCollectionSet!

        if filteredNames.isEmpty {
            let keys = Array(viewModel.pokemonCollectionSets.keys)
            pokemonSet = viewModel.pokemonCollectionSets[keys[indexPath.row]]
        } else {
            pokemonSet = viewModel.pokemonCollectionSets[filteredNames[indexPath.row]]
        }
        let destination = SetDetailsModuleBuilder.build(usingNavigationFactory: NavigationBuilder.build, andPokemonSet: pokemonSet)
        if let destination = destination as? SetDetailsViewController {
            destination.configure(withViewModel: SetDetailsViewModel(setDetails: SetDetails(id: pokemonSet.id,
                                                                                            userSet: UserSet(id: pokemonSet.id, cardsCollected: 0),
                                                                                            pokemonCollectionSet: pokemonSet),
                                                                     delegate: destination))
        }
        self.navigationController?.pushViewController(destination, animated: true)
//        self.navigationController?.pushViewController(destination, animated: true)
    }
}
// MARK: - ViewModel Delegate Methods
extension PokemonCollectionSetsViewController: PokemonCollectionViewModelDelegate {

    func isLoadingPokemonCollectionSetsViewModel(_ pokemonCollectionSetsViewModel: PokemonCollectionSetsViewModel) {

    }

    func didLoadPokemonCollectionSetsViewModel(_ pokemonCollectionSetsViewModel: PokemonCollectionSetsViewModel) {
        self.pokemonCollectionSetsCollectionView.reloadData()
        self.configureSearchView()
    }

    func didFailWithError(message: String) {
        DispatchQueue.main.async {
            self.showErrorAlert(with: message)
        }
    }

    func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Pokemon Sets Unavailable!", message: message, preferredStyle: .alert)
        let alertOKAction=UIAlertAction(title: "OK", style: .default, handler: { _ in })
        alert.addAction(alertOKAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - CollectionView DataSource Methods
extension PokemonCollectionSetsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredNames.isEmpty ? viewModel.pokemonCollectionSets.count : filteredNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? PokemonCollectionSetCell else {
            return UICollectionViewCell()
        }
        if filteredNames.isEmpty {
            let keys = Array(viewModel.pokemonCollectionSets.keys)
            cell.configure(with: viewModel.pokemonCollectionSets[keys[indexPath.row]]!)
        } else {
            cell.configure(with: viewModel.pokemonCollectionSets[filteredNames[indexPath.row]]!)
        }
        return cell
    }

}

// MARK: - SearchBar Delegate Methods

extension PokemonCollectionSetsViewController:  CustomSearchbarViewDelegate {
    func updateDisplay(_ sender: CustomSearchBarViewModel!, withSearchFilter searchFilter: String!) {
        self.filteredNames = sender.filteredList as? [String] ?? [String]()
        self.filteredNames = self.filteredNames.map { $0.setID }
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
