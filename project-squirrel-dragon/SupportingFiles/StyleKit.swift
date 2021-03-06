//
//  StyleKit.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/08.
//

import UIKit

struct StyleKit {
    static let cellBorderColor = UIColor(ciColor: .white).cgColor
    static let borderWidth: CGFloat = 1

    struct Alpha {
        static let selected: CGFloat = 1
        static let unselected: CGFloat = 0.5
    }
    struct Cards {
        static let cornerRadius:CGFloat = 10
    }
}
