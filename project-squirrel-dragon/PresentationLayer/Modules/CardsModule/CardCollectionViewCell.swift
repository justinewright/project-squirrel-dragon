//
//  CardCollectionViewCell.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/10.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var ownedImageView: UIImageView!
    @IBOutlet weak var rarityImageView: UIImageView!
    @IBOutlet weak var collectedNumberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
