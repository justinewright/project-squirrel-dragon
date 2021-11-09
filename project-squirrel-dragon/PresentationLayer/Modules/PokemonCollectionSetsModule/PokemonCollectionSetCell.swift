//
//  CollectionViewCell.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/07.
//

import UIKit

class PokemonCollectionSetCell: UICollectionViewCell {

    // MARK: - Properties
    @IBOutlet private weak var pokemonCollectionSetImageView: UIImageView!
    private var urlString: String = ""
    private let cornerRadius: CGFloat = 10
    private let borderWidth: CGFloat = 1
    private let borderColour: CGColor = StyleKit.cellBorderColor

    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
    }

    func configure(with pokemonCollectionSet: PokemonCollectionSet) {
        urlString = pokemonCollectionSet.imageLogo
        configurePokemonCollectionSetImageView()
    }

    private func configurePokemonCollectionSetImageView() {
        guard let url = URL(string: urlString) else { return }
        pokemonCollectionSetImageView.load(url: url)

    }

    private func applyStyle() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColour
    }

}
