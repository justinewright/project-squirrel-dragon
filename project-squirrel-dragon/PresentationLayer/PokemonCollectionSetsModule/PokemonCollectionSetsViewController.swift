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

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        configureCollectionView()
    }

    private func configureCollectionView() {
        pokemonCollectionSetsCollectionView.dataSource = self
        pokemonCollectionSetsCollectionView.register(PokemonCollectionSetCell.self,
                                     forCellWithReuseIdentifier: cellReuseIdentifier)
        pokemonCollectionSetsCollectionView.register(UINib(nibName: cellNibName, bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        pokemonCollectionSetsCollectionView.backgroundColor = .clear
    }

}

// MARK: - ViewModel Delegate Methods
extension PokemonCollectionSetsViewController: PokemonCollectionViewModelDelegate {

    func isLoadingPokemonCollectionSetsViewModel(_ pokemonCollectionSetsViewModel: PokemonCollectionSetsViewModel) {

    }

    func didLoadPokemonCollectionSetsViewModel(_ pokemonCollectionSetsViewModel: PokemonCollectionSetsViewModel) {
        DispatchQueue.main.async {
            self.pokemonCollectionSetsCollectionView.reloadData()
        }
    }

    func didFailWithError(message: String) {

    }
}

// MARK: - CollectionView DataSource Methods
extension PokemonCollectionSetsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.pokemonCollectionSets.isEmpty ? 0 : 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? PokemonCollectionSetCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: viewModel.pokemonCollectionSets[indexPath.row])
        return cell
    }

}
