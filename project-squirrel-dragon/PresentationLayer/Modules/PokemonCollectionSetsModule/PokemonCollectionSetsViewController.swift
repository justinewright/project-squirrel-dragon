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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private lazy var viewModel = PokemonCollectionSetsViewModel(pokemonCollectionViewModelDelegate: self, repository: PokemonCollectionSetsRepository())
    private let cellReuseIdentifier = "PokemonCollectionSetCell"
    private let cellNibName = "PokemonCollectionSetCell"
    private var searchBarViewController = UIViewController()

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        configureCollectionView()
        viewModel.fetchViewData()
        activityIndicator.startAnimating()
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
        searchBarViewController = CustomSearchBarModuleBuilder.build()
        guard let configuredSearchBar = searchBarViewController as? CustomSearchBarViewController else {
            return
        }
        if let searchBarViewModel = CustomSearchBarViewModel(list: viewModel.searchList,
                                                             andDelegate: self) {
            configuredSearchBar.configure(searchBarViewModel)
            addChild(searchBarViewController)
            view.addSubview(searchBarViewController.view)
            searchBarViewController.didMove(toParent: self)
            constrainSearchBar()
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

        let destination = SetDetailsModuleBuilder.build(usingNavigationFactory: NavigationBuilder.build, andPokemonSet: viewModel.sets[Array(viewModel.sets.keys)[indexPath.row]]!)

        self.navigationController?.pushViewController(destination, animated: true)
    }
}
// MARK: - ViewModel Delegate Methods
extension PokemonCollectionSetsViewController: PokemonCollectionViewModelDelegate {

    func didLoadPokemonCollectionSetsViewModel(_ pokemonCollectionSetsViewModel: PokemonCollectionSetsViewModel) {
        self.pokemonCollectionSetsCollectionView.reloadData()
        self.configureSearchView()
        activityIndicator.stopAnimating()
    }

    func didFailWithError(message: String) {
        self.showErrorAlert(with: message)
        activityIndicator.stopAnimating()
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
        viewModel.sets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? PokemonCollectionSetCell,
              let cellData = viewModel.sets[viewModel.keys[indexPath.row]] else {
            return UICollectionViewCell()
        }
        cell.configure(with: cellData )

        return cell
    }

}

// MARK: - SearchBar Delegate Methods

extension PokemonCollectionSetsViewController:  CustomSearchbarViewDelegate {
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
