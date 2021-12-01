//
//  InterfaceController.swift
//  project-squirrel-dragon Watch WatchKit Extension
//
//  Created by Justine Wright on 2021/11/24.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var button: WKInterfaceButton!

    let colors: [UIColor] = ["E50012","F39600"].map { (str) -> UIColor in
        return UIColor.colorWithHexString(hex: str)
    }

    @IBOutlet weak var progress: WKInterfaceImage!

    @IBOutlet weak var progress1: WKInterfaceImage!

    var session = WCSession.default

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        session.delegate = self
        session.activate()
        //progress.setImageNamed("progress")
        //progress.startAnimating()

        /**
            Range - progress0 to progress80 images will be animated
            Duration - Animation time
            Repeatcount - how many time animation will performed. -1 mean infinite
        */
        //progress1.setImageNamed("progress")
        //progress1.startAnimatingWithImages(in: NSMakeRange(0, 80), duration: 1, repeatCount: -1)
    }

    @IBAction func collectedNumbersPressed() {
        let dataToPhone: [String: Any] = ["watchMode": "cardCollectionStats" as Any]
        session.sendMessage(dataToPhone, replyHandler: nil, errorHandler: nil)
        print("sending message")
    }
    
    override func willActivate() {
        super.willActivate()
        let dataToPhone: [String: Any] = ["watchMode": "cardCollectionStats" as Any]
        session.sendMessage(dataToPhone, replyHandler: nil, errorHandler: nil)
        print("sending message")
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
//
//    @IBAction func animateProgress() {
//        startProgress(bar: progress, color: colors[0], range: NSMakeRange(0, 40))
//    }
//
//    @IBAction func animateProgress1() {
//        startProgress(bar: progress1, color: colors[1], range: NSMakeRange(0, 80))
//    }
//
//    @IBOutlet weak var totalProgress: WKInterfaceLabel!
//    func startProgress(bar: WKInterfaceImage, color: UIColor, range: NSRange) {
//        let animation = UIImage.animatedImage(with: self.animateImage("progress", color), duration: 1)
//        bar.setImage(animation)
//        bar.startAnimatingWithImages(in: range, duration: 1, repeatCount: 1)
//    }
//
//    func animateImage(_ imageName: String, _ color: UIColor) -> [UIImage] {
//        var images: [UIImage] = []
//        (0...100).forEach { (index) in
//            if let img = UIImage(named: "\(imageName)\(index)") {
//                images.append(img.imageMasked(with: color))
//            }
//        }
//        return images
//    }
}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let valueFromPhone = message["collectedStats"] as? [String: Any] {
            let collectedStats = CollectedCardsStats(dictionary: valueFromPhone)
            DispatchQueue.main.async {
                self.totalProgress.setText("\(collectedStats.totalPercentage)%")
            }
        }

    }
}


extension UIImage {
    func imageMasked(with maskColor: UIColor) -> UIImage {
        let imageRect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        var newImage: UIImage? = nil
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, self.scale)
        do {
            let context = UIGraphicsGetCurrentContext()!
            context.scaleBy(x: 1.0, y: -1.0)
            context.translateBy(x: 0.0, y: -(imageRect.size.height))
            context.clip(to: imageRect, mask: self.cgImage!)
            context.setFillColor(maskColor.cgColor)
            context.fill(imageRect)
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
        }
        UIGraphicsEndImageContext()
        return newImage!
    }

}

extension UIColor {

    @objc class func colorWithHexString (hex:String) -> UIColor {

        var hexWithoutSymbol:String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()

        if (hexWithoutSymbol.hasPrefix("#")) {
            hexWithoutSymbol = (hexWithoutSymbol as NSString).substring(from: 1)
        }

        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)

        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.count) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            r = 0
            g = 0
            b = 0
            break;
        }
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }

}

