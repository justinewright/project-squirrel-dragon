//
//  CardsCollectionViewController.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/10.
//

import Foundation

class CardsCollectionViewController: UIViewController {

    private let errorTitle = "Pokemon Cards Unavailable!"

    // MARK: - Properties
    @IBOutlet private weak var commonLabel: UILabel!
    @IBOutlet private weak var uncommonLabel: UILabel!
    @IBOutlet private weak var rareLabel: UILabel!
    @IBOutlet private weak var promoLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet private weak var collectionView: UICollectionView!

    @IBOutlet private weak var unownedButton: UIButton!
    @IBOutlet private weak var ownedButton: UIButton!
    @IBOutlet private weak var allButton: UIButton!
    private let cellReuseIdentifier = CardCollectionViewCell.reuseIdentity
    private let cellNibName = CardCollectionViewCell.reuseIdentity

    private lazy var viewModel = CardsCollectionViewModel(
        delegate: self,
        pokemonCardsRepository: TCGPokemonRepository(apiClient: PokemonTcgApiClient(endPoint: Endpoint(path: "cards"), forDataType: TCGReturnDataTypes.TcgCards)),

        userCardsRepository: UserPokemonDataRepository(firebaseApiClient: FirebaseApiClient(endPoint: Endpoint(path: "cards"), forDataType: UserReturnDataTypes.UserCards)),
        userSetRepository: UserPokemonDataRepository(firebaseApiClient: FirebaseApiClient(endPoint: Endpoint(path: "sets"), forDataType: UserReturnDataTypes.UserSets)))

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        configureCollectionView()
        viewModel.fetchViewData()
    }
    // MARK: - Configuration Methods
    func configure(forSetID setID: String) {
        viewModel.configure(forSetID: setID)
    }

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardCollectionViewCell.self,
                                forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.register(UINib(nibName: cellNibName, bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.backgroundColor = .clear
    }

    // MARK: - Gestures Methods
    @IBAction func AllButtonPressed(_ sender: UIButton) {
        deselectAllButtons()
        selectButton(button: sender)
    }
    
    @IBAction func OwnedButtonPressed(_ sender: UIButton) {
        deselectAllButtons()
        selectButton(button: sender)
    }

    @IBAction func UnownedButtonPressed(_ sender: UIButton) {
        deselectAllButtons()
        selectButton(button: sender)
    }

    private func deselectAllButtons() {
        unownedButton.isSelected = false
        ownedButton.isSelected = false
        allButton.isSelected = false
    }

    private func selectButton(button: UIButton) {
        button.isSelected = true
    }
}

// MARK: - UICollection Datasource Methods
extension CardsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.pokemonCards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? CardCollectionViewCell else {
            return UICollectionViewCell()
        }
        let animation = AnimationFactory.makeFadeAnimation(duration: 0.5,
                                                           delayFactor: 0.05)
        let animator = Animator(animation: animation)
        cell.configure(with: viewModel.collectableCards[indexPath.row] )
        animator.animate(cell: cell, at: indexPath, in: collectionView)
        return cell
    }
}

// MARK: - UICollection Delegate Methods
extension CardsCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else {
            return
        }

        handleSelectCard(forCard: cell.collectableCard)
    }

    private func handleSelectCard(forCard card: CollectableCard) {
        let navVC = CardDetailModuleBuilder.build(usingNavigationFactory: NavigationBuilder.build, and: card)
        
        guard let destination = navVC.children.first as? CardDetailViewController else {
            return
        }

        destination.modalPresentationStyle = .fullScreen
        navVC.modalPresentationStyle = .fullScreen

        self.present(navVC, animated: true, completion: nil)
        destination.callback = { (cardId, collectedCards) -> Void in
            navVC.dismiss(animated: true)
            guard let _cardId = cardId,
                  let _collectedCards = collectedCards  else {
                      return
                  }
            self.viewModel.postCard(cardId: _cardId,
                                    withCollectedNumber: _collectedCards)

        }
    }
}

extension CardsCollectionViewController: CardsCollectionViewModelDelegate {
    func didLoadCardsCollectionViewModel(_ cardsCollectionViewModel: CardsCollectionViewModel) {
        self.collectionView.reloadData()
        activityIndicator.stopAnimating()
    }

    func didFailWithError(message: String) {
        self.showErrorAlert(titled: errorTitle, with: message)
        activityIndicator.stopAnimating()
    }
}
