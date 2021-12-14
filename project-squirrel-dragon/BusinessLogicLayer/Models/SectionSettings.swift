//
//  SectionSettings.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/12/13.
//

import Foundation

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

enum SettingSection: Int, CaseIterable, CustomStringConvertible {
    case Account
    case App
    case Logout

    var description: String {
        switch self {
        case .App: return "App Settings"
        case .Account: return ""
        case .Logout: return ""
        }
    }
}

enum AccountOptions: Int, CaseIterable, SectionType {
    case Account

    var containsSwitch: Bool { return false }

    var description: String {
        switch self {
        case .Account: return "Account"
        }
    }

    var settingOption: SettingsOption {
        switch self {
        case .Account:
            return SettingsOption(detail: nil,
                                  icon: UIImage(systemName: "person.fill"),
                                  iconBackgroundColor: .lightGray,
                                  iconTintColor: .lightGray.darker(by: 0.7),
                                  sectionColor: .normalSectionColor,
                                  accessory: .disclosureIndicator )
        }
    }
}

enum ApplicationOptions: Int, CaseIterable, SectionType {
    case Currency
    case Watch

    var containsSwitch: Bool {
        switch self {
        case .Currency: return false
        case .Watch: return true
        }
    }

    var description: String {
        switch self {
        case .Currency: return "Currency"
        case .Watch: return "Watch"
        }
    }

    var settingOption: SettingsOption {
        switch self {
        case .Currency:
            return SettingsOption(detail: UserDefaults.standard.currency,
                                  icon: UIImage(systemName: "banknote.fill"),
                                  iconBackgroundColor: .green.darker(by: 0.5),
                                  iconTintColor: .green.darker(by: 0.7),
                                  sectionColor: .normalSectionColor,
                                  accessory: .disclosureIndicator)
        case .Watch:
            return SettingsOption(detail: nil,
                                  icon: UIImage(systemName: "applewatch"),
                                  iconBackgroundColor: .darkGray,
                                  iconTintColor: .darkGray.lighter(by: 0.7),
                                  sectionColor: .normalSectionColor,
                                  accessory: .none)
        }
    }
}

enum LogoutOptions: Int, CaseIterable, SectionType {
    case Logout

    var containsSwitch: Bool {
        switch self {
        case .Logout: return false
        }
    }

    var description: String {
        switch self {
        case .Logout: return "Logout"
        }
    }

    var settingOption: SettingsOption {
        switch self {
        case .Logout:
            return SettingsOption(detail: nil,
                                  icon: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                                  iconBackgroundColor: .clear,
                                  iconTintColor: .red.darker(by: 0.5),
                                  sectionColor: .logoutSectionColor,
                                  accessory: .none)
        }
    }
}
