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

        if let searchBarViewModel = CustomSearchBarViewModel(list: Array(viewModel.pokemonCollectionSets.keys), andDelegate: self) {
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
