//
//  InterfaceController.swift
//  project-squirrel-dragon Watch WatchKit Extension
//
//  Created by Justine Wright on 2021/11/24.
//

import WatchKit
import Foundation
import WatchConnectivity
import UIKit
import SwiftUI

class InterfaceController: WKInterfaceController {

    // MARK: - Properties
    private var fillColor = #colorLiteral(red: 0.6862745098, green: 0.3215686275, blue: 0.8705882353, alpha: 1)
    @IBOutlet private weak var totalProgressLabel: WKInterfaceLabel!

    @IBOutlet private weak var commonPercentageLabel: WKInterfaceLabel!
    @IBOutlet private weak var commonBackgroundProgress: WKInterfaceImage!
    @IBOutlet private weak var commonProgress: WKInterfaceImage!

    @IBOutlet private weak var uncommonPercentageLabel: WKInterfaceLabel!
    @IBOutlet private weak var uncommonBackgroundProgress: WKInterfaceImage!
    @IBOutlet private weak var uncommonProgress: WKInterfaceImage!

    @IBOutlet private weak var rarePercentageLabel: WKInterfaceLabel!
    @IBOutlet private weak var rareBackgroundProgress: WKInterfaceImage!
    @IBOutlet private weak var rareProgressBar: WKInterfaceImage!

    @IBOutlet private weak var promoPercentageLabel: WKInterfaceLabel!
    @IBOutlet private weak var promoProgress: WKInterfaceImage!
    @IBOutlet private weak var promoBackgroundProgress: WKInterfaceImage!

    private var progressBarImages: [UIImage] = []
    private var animationDuration: Double = 1

    private var session = WCSession.default

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        session.delegate = self
        session.activate()
        progressBarImages = animateImage("progress", fillColor)
        uncommonPercentageLabel.setAlpha(0)
        rarePercentageLabel.setAlpha(0)
        promoPercentageLabel.setAlpha(0)
        commonPercentageLabel.setAlpha(0)
    }

    private func configureProgressDisplay(forPercentageLabel label: WKInterfaceLabel, andProgressBar progressBar: WKInterfaceImage, withPercentage percent: Int) {
        startProgress(bar: progressBar, color: fillColor, range:NSRange(location: 0, length: percent))
        label.setAlpha(0)
        animate(withDuration: animationDuration / 2) {
            label.setAlpha(1)
            label.setText("\(percent)%")
        }
    }

    private func fetchProgressCollectionStats() {
        let dataToPhone: [String: Any] = ["watchMode": "cardCollectionStats" as Any]
        session.sendMessage(dataToPhone, replyHandler: nil, errorHandler: nil)
    }

    @IBAction func collectedNumbersPressed() {
        fetchProgressCollectionStats()
    }
    
    override func willActivate() {
        super.willActivate()
        fetchProgressCollectionStats()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    func startProgress(bar: WKInterfaceImage, color: UIColor, range: NSRange) {
        let animation = UIImage.animatedImage(with: progressBarImages, duration: 1)
        bar.setImage(animation)
        bar.startAnimatingWithImages(in: range, duration: 1, repeatCount: 1)
    }

    func animateImage(_ imageName: String, _ color: UIColor) -> [UIImage] {
        var images: [UIImage] = []
        (0...100).forEach { (index) in
            if let img = UIImage(named: "\(imageName)\(index)") {
                images.append(img.imageMasked(with: color))
            }
        }
        return images
    }
}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let valueFromPhone = message["collectedStats"] as? [String: Any] {
            let collectedStats = CollectedCardsStats(dictionary: valueFromPhone)
            self.totalProgressLabel.setText("\(collectedStats.totalPercentage)%")
            configureProgressDisplay(forPercentageLabel: commonPercentageLabel,
                                     andProgressBar: commonProgress,
                                     withPercentage: collectedStats.commonCardsPercentage)

            configureProgressDisplay(forPercentageLabel: uncommonPercentageLabel,
                                     andProgressBar: uncommonProgress,
                                     withPercentage: collectedStats.uncommonCardsPercentage)

            configureProgressDisplay(forPercentageLabel: rarePercentageLabel,
                                     andProgressBar: rareProgressBar,
                                     withPercentage: collectedStats.rareCardsPercentage)

            configureProgressDisplay(forPercentageLabel: promoPercentageLabel,
                                     andProgressBar: promoProgress,
                                     withPercentage: collectedStats.promoCardsPercentage)

        }
    }
}
