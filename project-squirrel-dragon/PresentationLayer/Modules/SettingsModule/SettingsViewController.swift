//
//  SettingsViewController.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/12/08.
//

import UIKit

extension UIColor
{
    static let normalSectionColor: UIColor = .quaternaryLabel
    static let logoutSectionColor: UIColor = .red
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // configure options handlers
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseidentifier)
        tableView.register(UINib(nibName: SettingTableViewCell.reuseidentifier, bundle: nil), forCellReuseIdentifier: SettingTableViewCell.reuseidentifier)

    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingSection.allCases.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear

        let title = UILabel()
        title.text = SettingSection(rawValue: section)?.description
        title.font = .boldSystemFont(ofSize: 16)
        title.textColor = .white
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true

        return view
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseidentifier, for: indexPath)
        guard let settingsCell = cell as? SettingTableViewCell else { return UITableViewCell() }
        guard let section = SettingSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .Account:
            let account = AccountOptions(rawValue: indexPath.row)
            settingsCell.sectionType = account
            settingsCell.configure(withSettingsOption: account!.settingOption)
        case .App:
            let app = ApplicationOptions(rawValue: indexPath.row)
            settingsCell.sectionType = app
            settingsCell.configure(withSettingsOption: app!.settingOption)
        case .Logout:
            let logout = LogoutOptions(rawValue: indexPath.row)
            settingsCell.sectionType = logout
            settingsCell.configure(withSettingsOption: logout!.settingOption)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingSection(rawValue: section) else { return 0 }
        switch section {
        case .App: return ApplicationOptions.allCases.count
        case .Account: return AccountOptions.allCases.count
        case .Logout: return LogoutOptions.allCases.count
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let section = SettingSection(rawValue: indexPath.section) else {return}
        switch section {
        case .Account:
            accountSectionClicked(withIndexPath: indexPath.row)
        case .App:
            appSectionClicked(withIndexPath: indexPath.row)
        case .Logout:
            logoutSectionClicked()
        }
    }

    func accountSectionClicked(withIndexPath indexPath: Int) {
        let accountOption = AccountOptions(rawValue: indexPath)
        switch accountOption {
        case .Account:
            //TODO: - navigate to account page
            break
        case .none:
            break
        }
    }

    func appSectionClicked(withIndexPath indexPath: Int) {
        let applicationOption = ApplicationOptions(rawValue: indexPath)
        switch applicationOption {
        case .Currency:
            handleCurrencySelect()
            //TODO: - navigate to account page
            break
        case .Watch:
            //TODO: - feature toggle watch
            break
        case .none:
            break
        }
    }
    private func handleCurrencySelect() {
//        let navVC = CardDetailModuleBuilder.build(usingNavigationFactory: NavigationBuilder.build, and: card)
        // put in builder
        let storyboard = UIStoryboard.init(name: "Currency", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "Currency")
        view.title = "Currency"
        let navVC = NavigationBuilder.build(rootView: view)
        guard let destination = navVC.children.first as? CurrencyViewController else {
            return
        }

        destination.modalPresentationStyle = .fullScreen
        navVC.modalPresentationStyle = .fullScreen

        self.present(navVC, animated: true, completion: nil)
        destination.callback = { () -> Void in
            navVC.dismiss(animated: true)
            self.tableView.reloadData()

        }
    }
    func logoutSectionClicked() {
        //TODO: - logout and navigate to starting page
    }


}

extension SettingsViewController: UITableViewDelegate {

}
