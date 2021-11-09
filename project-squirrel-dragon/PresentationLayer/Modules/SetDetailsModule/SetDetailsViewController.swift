//
//  SetDetailsViewController.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/20.
//

import UIKit

class SetDetailsViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var cardsImageView: UIImageView!
    @IBOutlet private weak var collectedPercentageLabel: UILabel!
    @IBOutlet private weak var collectedFractionLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!

    private let errorTitle = "User Details Unavailable!"
    // add to user set
    // tap all sets u want to add : o
    // done button
    // TODO: - add currency selector / converter and view cards button

    private lazy var viewModel = SetDetailsViewModel(delegate: self)

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        configure()
    }

    // MARK: - Initialization
    func configure(withPokemonCollectionSet set: PokemonCollectionSet) {
        self.viewModel.updateSetDetailsData(withPokemonSet: set)
    }

    private func configure() {
        configureTitle(title: viewModel.setDetails.pokemonCollectionSet.series)
        configureTopView(withURL: viewModel.logoURL,
                         andReleaseDate: viewModel.formatedReleaseDate)
        configureMiddleView(withCollectedFraction:
                                viewModel.collectedFraction,
                            withcollectedPercentage: viewModel.collectedPercentage)
        configureBottomView(withValue: 0.0)
    }

    private func configureTitle(title: String) {
        self.title = title
    }

    private func configureTopView(withURL url: URL?, andReleaseDate releaseDate: String) {
        releaseDateLabel.text = releaseDate
        guard let url = url else { return }
        logoImageView.load(url: url)
    }

    private func configureMiddleView(withCollectedFraction fraction: String, withcollectedPercentage percentage: String = "0%" ) {
        collectedFractionLabel.text = fraction
        collectedPercentageLabel.text = percentage
    }

    private func configureBottomView(withValue value: Float) {
        valueLabel.text = "\(value)"
    }

}

extension SetDetailsViewController: SetsDetailViewModelDelegate {
    func didLoadSetDetailsViewModel(_ setDetailsViewModel: SetDetailsViewModel) {
        configure()
    }

    func didFailWithError(message: String) {
        self.showErrorAlert(titled: errorTitle, with: message)
    }
}
