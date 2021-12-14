//
//  CurrencyViewController.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/12/13.
//

import UIKit

class CurrencyViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var callback: (() -> Void)!

    private lazy var viewModel = CurrencyViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }

}

extension CurrencyViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(withSearchText: searchText)
        tableView.reloadData()
    }
}

extension CurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.currency =  viewModel.filteredList[indexPath.row]
        callback()
    }
}

extension CurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = viewModel.filteredList[indexPath.row]
        cell.contentConfiguration = config
        return cell
    }

}
