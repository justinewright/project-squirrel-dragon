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
    @IBOutlet private weak var nationalPokedexNumberLabel: UILabel!
    @IBOutlet private weak var cardImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var rarityLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var pricesLabel: UILabel!
    @IBOutlet private weak var collectedNumberTextField: UITextField!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
    @IBOutlet private weak var pricesNumberLabel: UILabel!
    @IBOutlet private weak var cardFront: UIView!
    @IBOutlet private weak var cardBack: UIView!
    @IBOutlet private weak var card: UIView!

    private lazy var viewModel = CardDetailViewModel()

    // MARK: - Life Cycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        card.layer.cornerRadius = StyleKit.Cards.cornerRadius
        collectedNumberTextField.keyboardType = .numberPad
        collectedNumberTextField.delegate = self
        configureCardImageView()
        configureNumberLabel()
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

    private func configureNumberLabel() {
        configureLabel(numberLabel,
                       withText: viewModel.number)
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
                       withText: viewModel.prices.0)
        configureLabel(pricesNumberLabel,
                       withText: viewModel.prices.1)
    }

    private func configureTextField() {
        collectedNumberTextField.text = "\(viewModel.totalCardsCollected)"
    }
    // MARK: - Gestures
    @IBAction func flipCardButtonPressed(_ sender: UIButton) {
    if cardBack.isHidden {
        flipAnimation(inContainer: self.card,
                      fromView: cardFront,
                      toView: cardBack,
                      animationOption: .transitionFlipFromRight)

        } else if cardFront.isHidden {
            flipAnimation(inContainer: self.card,
                          fromView: cardBack,
                          toView: cardFront,
                          animationOption: .transitionFlipFromLeft)
        }
    }

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

    // MARK: - Animations
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
}

extension CardDetailViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showAlertWithUITextField(titled: "Cards Collected",
                                 withMessage: "How many have you got?",
                                 andPlaceHolder: "\(viewModel.totalCardsCollected)",
                                 handler: handleUpdateCardsCollected)

    }

    func handleUpdateCardsCollected(textField: UITextField) -> (_ alertAction: UIAlertAction) -> Void {
        return { _ in
            self.viewModel.totalCardsCollected =  Int(textField.text ?? "0") ?? 0
            self.configureTextField()
        }
    }
}

