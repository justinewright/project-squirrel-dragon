//
//  CardCollectionViewCell.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/10.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    @IBOutlet private weak var cardImageView: UIImageView!
    @IBOutlet private weak var ownedImageView: UIImageView!
    @IBOutlet private weak var rarityImageView: UIImageView!
    @IBOutlet private weak var collectedNumberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
    }
    // MARK: - Configuration Methods
    func applyStyle() {
        backgroundView?.alpha = StyleKit.Alpha.unselected
    }

    func configure(with collectableCard: CollectableCard) {
        configureCollectedNumberLabel(withNumberText:  "\(collectableCard.userCard.collectedNumber)")
        configureOwnedImageView(setOwned: collectableCard.userCard.collectedNumber > 0)
        configureCardImageView(withURLString: collectableCard.cardImages.small)
    }

    private func configureCollectedNumberLabel(withNumberText numberText: String) {
        collectedNumberLabel.text = numberText

    }
    private func configureCardImageView(withURLString urlString: String) {
        guard let url = URL(string: urlString) else {return}
        cardImageView.load(url: url)
    }

    private func configureOwnedImageView(setOwned: Bool) {
        let imageName = setOwned ? "checkmark.circle.fill" : "circle"
        let image = UIImage(systemName: imageName)
        ownedImageView.image = image
    }

    override var isSelected: Bool {
        willSet(newValue) {
            selectedBackgroundView?.alpha = StyleKit.Alpha.selected
            configureOwnedImageView(setOwned: newValue)
        }
    }
    
}
