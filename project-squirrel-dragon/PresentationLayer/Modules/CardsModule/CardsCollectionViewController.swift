//
//  CardsCollectionViewController.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/10.
//

import Foundation

class CardsCollectionViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var commonLabel: UILabel!
    @IBOutlet private weak var uncommonLabel: UILabel!
    @IBOutlet private weak var rareLabel: UILabel!
    @IBOutlet private weak var promoLabel: UILabel!

    @IBOutlet private weak var collectionView: UICollectionView!

    @IBOutlet private weak var unownedButton: UIButton!
    @IBOutlet private weak var ownedButton: UIButton!
    @IBOutlet private weak var allButton: UIButton!

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

extension CardsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}
