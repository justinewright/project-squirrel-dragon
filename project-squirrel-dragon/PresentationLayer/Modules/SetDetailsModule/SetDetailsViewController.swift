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
    // TODO: - add currency selector / convertor

    private weak var viewModel: SetDetailsViewModel!

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Initialization
    func configure(withViewModel viewModel: SetDetailsViewModel) {
        self.viewModel = viewModel
        self.viewModel.updateView()
    }

    private func configure() {
        configureTitle(title: viewModel.setDetails.pokemonCollectionSet.name)
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
        releaseDateLabel.text = releaseDate
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
