//
//  SetDetailsViewController.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/20.
//

import UIKit

class SetDetailsViewController: UIViewController {
    // MARK: - Properties
    // top view
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    // middle view
    @IBOutlet private weak var cardsImageView: UIImageView!
    @IBOutlet private weak var collectedPercentageLabel: UILabel!
    @IBOutlet private weak var collectedFractionLabel: UILabel!
    // bottom view
    @IBOutlet private weak var valueLabel: UILabel!

    // TODO: - add currency selector / converter and view cards button

    private lazy var viewModel = SetDetailsViewModel (setDetails: DummyData.pokemonSet, delegate: self)

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.viewModel.updateView()
    }

    // MARK: - Initialization
    func configure(withViewModel viewModel: SetDetailsViewModel) {
        self.viewModel = viewModel
    }

    private func configure() {
        configureTitle(title: viewModel.setDetails.pokemonCollectionSet.series)
        configureTopView(withURL: viewModel.setDetails.pokemonCollectionSet.imageLogo,
                         andReleaseDate: viewModel.setDetails.pokemonCollectionSet.releaseDate)
        configureMiddleView(withCollectedFraction: viewModel.setDetails.collectedFraction,
                            withcollectedPercentage: viewModel.setDetails.collectedPercentage)
        configureBottomView(withValue: 0.0)
    }

    private func configureTitle(title: String) {
        self.title = title
    }

    private func configureTopView(withURL urlString: String, andReleaseDate releaseDate: String) {
        releaseDateLabel.text = "RELEASE DATE: " + releaseDate
        guard let url = URL(string: urlString) else { return }
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
    func isLoadingSetDetailsViewModel(_ setDetailsViewModel: SetDetailsViewModel) {
        configure()
    }

    func didLoadSetDetailsViewModel(_ setDetailsViewModel: SetDetailsViewModel) {
        configure()
    }

    func didFailWithError(message: String) {

    }

}
