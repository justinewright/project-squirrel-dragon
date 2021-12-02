//
//  UIImage+Extensions.swift
//  project-squirrel-dragon Watch WatchKit Extension
//
//  Created by Justine Wright on 2021/12/02.
//

import UIKit

extension UIImage {
    func imageMasked(with maskColor: UIColor) -> UIImage {
        let imageRect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        var newImage: UIImage?
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
