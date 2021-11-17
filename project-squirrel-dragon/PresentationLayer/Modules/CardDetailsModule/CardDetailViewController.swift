//
//  CardsDetailViewController.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/12.
//

import UIKit

class CardDetailViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet weak var nationalPokedexNumberLabel: UILabel!
    @IBOutlet private weak var cardImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var rarityLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var pricesLabel: UILabel!
    @IBOutlet weak var collectedNumberTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!

    @IBOutlet weak var cardFront: UIView!
    @IBOutlet weak var cardBack: UIView!
    @IBOutlet weak var card: UIView!


    fileprivate func flipAnimation(inContainer viewContainer: UIView, fromView view1: UIView, toView view2: UIView, animationOption: UIView.AnimationOptions) {
        //change hidden state half way through animation using delay
        UIView.transition(with: viewContainer, duration: 0.5, options: [animationOption], animations:{
            let delay = 0.25
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: { () -> Void in
                view1.isHidden = true
                view2.isHidden = false
            })
        }, completion: nil)
    }

    @IBAction func flipCardButtonPressed(_ sender: UIButton) {

        if cardBack.isHidden == true {
            flipAnimation(inContainer: self.card,
                          fromView: cardFront,
                          toView: cardBack,
                          animationOption: .transitionFlipFromRight)

            } else if cardFront.isHidden == true {
                flipAnimation(inContainer: self.card,
                              fromView: cardBack,
                              toView: cardFront,
                              animationOption: .transitionFlipFromLeft)
            }
        }

    private lazy var viewModel = CardDetailViewModel()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        card.layer.cornerRadius = StyleKit.Cards.cornerRadius
        collectedNumberTextField.keyboardType = .numberPad
        collectedNumberTextField.delegate = self
        configureCardImageView()
        configureNationalPokedexNumberLabel()
        configureNameLabel()
        configureRarityLabel()
        configureTypeLabel()
        configurePricesLabel()
        configureTextField()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    var callback: ((_ cardId: String?, _ numberOfCollectedCards: Int?) -> Void)?

    // MARK: - Init
    public func configure(withCard card: CollectableCard) {
        viewModel.configure(withCard: card)
    }

    private func configureLabel(_ label: UILabel, withText text: String?) {
        guard let text = text else {
            label.isHidden = true
            return
        }
        label.text = text
    }

    private func configureNationalPokedexNumberLabel() {
        configureLabel(nationalPokedexNumberLabel,
                       withText: viewModel.nationalPokedexNumberLabel)
    }

    private func configureCardImageView() {
        guard let url = viewModel.cardImageUrl else {
            return
        }
        cardImageView.load(url: url)
    }

    private func configureNameLabel() {
        configureLabel(nameLabel,
                       withText: viewModel.pokemonName)
    }

    private func configureRarityLabel() {
        configureLabel(rarityLabel,
                       withText: viewModel.rarity)
    }

    private func configureTypeLabel() {
        configureLabel(typeLabel,
                       withText: viewModel.type)
    }

    private func configurePricesLabel() {
        configureLabel(pricesLabel,
                       withText: viewModel.prices)
    }

    private func configureTextField() {
        collectedNumberTextField.text = "\(viewModel.totalCardsCollected)"
    }
    // MARK: - Gestures
    @IBAction func addButtonPressed(_ sender: UIButton) {
        viewModel.addOneCard()
        configureTextField()
    }

    @IBAction func minusButtonPressed(_ sender: UIButton) {
        viewModel.removeOneCard()
        configureTextField()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        callback?(viewModel.cardId, viewModel.finalCardsCollected)
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        callback?(nil, nil)
    }
}

extension CardDetailViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var textField = UITextField()

        let alert = UIAlertController(title: "How many have you collected?", message: "", preferredStyle: .alert)

        let actionOkay = UIAlertAction(title: "Done", style: .default) { (action) in
            self.viewModel.totalCardsCollected = Int(textField.text!) ?? 0
            self.configureTextField()
        }

        let actionCancel = UIAlertAction(title: "Cancel", style: .default) {_ in}

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "\(self.viewModel.totalCardsCollected)"
            textField = alertTextField
            alertTextField.keyboardType = .numberPad
        }

        alert.addAction(actionCancel)
        alert.addAction(actionOkay)
        present(alert, animated: true, completion: nil)
    }
}


