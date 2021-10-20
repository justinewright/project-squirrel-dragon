//
//  String+Extension.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/20.
//

import Foundation

extension String {
    public var setID: String {
        let result = self.split(separator: " ").map { String($0) }
        return result.last?.removeWhitespace ?? ""
    }

    subscript (bounds: CountableRange<Int>) -> Substring {
            let start = index(startIndex, offsetBy: bounds.lowerBound)
            let end = index(startIndex, offsetBy: bounds.upperBound)
            if end < start { return "" }
            return self[start..<end]
        }

    func replace(string:String, replacement:String) -> String {
         return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    var removeWhitespace: String {
            return self.replace(string: " ", replacement: "")
        }
}
