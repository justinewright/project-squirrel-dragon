//
//  CardCollectionViewCell.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/10.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseIdentity = "CardCollectionViewCell"
    @IBOutlet private weak var cardImageView: UIImageView!
    @IBOutlet private weak var rarityImageView: UIImageView!
    @IBOutlet private weak var ownedImageView: UIImageView!
    @IBOutlet private weak var collectedNumberLabel: UILabel!
    @IBOutlet private weak var avgLabel: UILabel!
    @IBOutlet private weak var trendingLabel: UILabel!

    private var collectableCard: CollectableCard!

    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
    }

    // MARK: - Configuration Methods
    func applyStyle() {
        alpha = StyleKit.Alpha.unselected
        layer.cornerRadius = StyleKit.Cards.cornerRadius
    }

    func configure(with collectableCard: CollectableCard) {
        self.collectableCard = collectableCard
        let numberOfCards = collectableCard.userCard == nil ? 0 : collectableCard.userCard?.collectedNumber
        configureCollectedNumberLabel(withNumberText: "\(numberOfCards!)")
        configureOwnedImageView(setOwned: numberOfCards! > 0)
        configureCardImageView(withURLString: collectableCard.pokemonCard.images.small)
        configurePriceLabels(withPrices: collectableCard.pokemonCard.cardmarket.prices)
        configureRarityImageView()
    }

    private func configurePriceLabels(withPrices prices: Prices) {
        configurePriceLabel(avgLabel, withNumberText: "\( prices.avg1 ?? 0)")
        configurePriceLabel(trendingLabel, withNumberText: "\(prices.trendPrice ?? 0)")
        trendingLabel.textColor = (prices.trendPrice ?? 0) > (prices.avg1 ?? 0) ? .green : .red
    }

    private func configurePriceLabel(_ label: UILabel, withNumberText numberText: String) {
        label.text = numberText
    }

    private func configureCollectedNumberLabel(withNumberText numberText: String) {
        collectedNumberLabel.text = numberText

    }

    private func configureCardImageView(withURLString urlString: String) {
        guard let url = URL(string: urlString) else {return}
        cardImageView.load(url: url)
    }

    private func configureRarityImageView() {
        let imageName = RarityImageNames[collectableCard.pokemonCard.rarity ?? ""] ?? ""
        let image = UIImage(systemName: imageName)
        rarityImageView.image = image
    }

    private func configureOwnedImageView(setOwned: Bool) {
        let imageName = setOwned ? "checkmark.circle.fill" : "circle"
        let image = UIImage(systemName: imageName)
        ownedImageView.image = image
    }

    override var isSelected: Bool {
        willSet(newValue) {
            selectedBackgroundView?.alpha = newValue ? StyleKit.Alpha.selected : StyleKit.Alpha.unselected
            configureOwnedImageView(setOwned: newValue)
        }
    }
    
}
