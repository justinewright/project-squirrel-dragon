//
//  CollectionViewCell.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/28.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(withSelectableSet selectableSet: SelectableSet) {
        configureNameLabel(withName: selectableSet.name)
        configureSelectedImageView(setSelected: selectableSet.selected)
        configureLogoImageView(withURLString: selectableSet.url)
    }

    private func configureNameLabel(withName name: String) {
        nameLabel.text = name

    }

    private func configureLogoImageView(withURLString urlString: String) {
        guard let url = URL(string: urlString) else {return}
        logoImageView.load(url: url)
    }

    private func configureSelectedImageView(setSelected: Bool) {
        let imageName = setSelected ? "checkmark.circle.fill" : "circle"
        let image = UIImage(systemName: imageName)
        selectedImageView.image = image
    }
}
