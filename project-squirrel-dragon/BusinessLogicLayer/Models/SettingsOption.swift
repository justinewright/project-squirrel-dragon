//
//  SettingsOption.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/12/08.
//

import Foundation
import UIKit
var callback: ((_ newSelectedSets: [String]?, _ deselectedSets: [String]?) -> Void)?

struct SettingsOption {
    let detail: String?
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let iconTintColor: UIColor
    let sectionColor: UIColor
    let accessory: UITableViewCell.AccessoryType
}
