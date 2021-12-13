//
//  SettingTableViewCell.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/12/08.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var sectionType: SectionType? {
        didSet {
            guard let sectionType = sectionType else {return}
            settingsLabel?.text = sectionType.description
            switchControl.isHidden = !sectionType.containsSwitch
            settingsLabelSelectedOption.isHidden = true
        }
    }

    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
        switchControl.onTintColor = .green
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        return switchControl
    }()

    static let reuseidentifier = "SettingTableViewCell"
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var settingsLabel: UILabel!
    @IBOutlet private weak var settingsLabelSelectedOption: UILabel!
    @IBOutlet private weak var imageContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        applyStyle()
    }

    func applyStyle() {
        imageContainerView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        settingsLabel.text = nil
        iconImageView.image = nil
    }

    public func configure(withSettingsOption settingsOption: SettingsOption) {
        iconImageView.image = settingsOption.icon?.withTintColor(settingsOption.iconTintColor, renderingMode: .alwaysOriginal)
        imageContainerView.backgroundColor = settingsOption.iconBackgroundColor

        if let settingsOptionDetail = settingsOption.detail {
            settingsLabelSelectedOption.isHidden = false
            settingsLabelSelectedOption.text = settingsOptionDetail
        }
        backgroundColor = settingsOption.sectionColor
        accessoryType = settingsOption.accessory
    }

    @objc func handleSwitchAction(sender: UISwitch) {
        //TODO: - feature toggle watch - maybe a call back function
        if sender.isOn {

        } else {

        }
    }

}
