//
//  CollectionViewCell.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/28.
//

import UIKit

class SelectableSetCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!

    private (set) var selectableSet: SelectableSet?

    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
    }

    func applyStyle() {
        layer.borderWidth = StyleKit.borderWidth
        layer.borderColor = StyleKit.cellBorderColor
    }

    func configure(with selectableSet: SelectableSet) {
        self.selectableSet = selectableSet
        configureNameLabel(withName: selectableSet.labelText)
        configureSelectedImageView(setSelected: selectableSet.selected)
        configureLogoImageView(withURLString: selectableSet.imageUrl)
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

    override var isSelected: Bool {
        willSet(newValue) {
            configureSelectedImageView(setSelected: newValue)
        }
    }
}
