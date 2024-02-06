//
//  MoviesViewController.swift
//  MoviesAppUIKit+Combine
//
//  Created by Vitalii Navrotskyi on 03.02.2024.
//

import UIKit

class MoviesViewController: UIViewController {


    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        return searchBar
    }()

    lazy var moviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        setupUI()
    }

    private func setupUI() {

    }


}

extension MoviesViewController: UISearchBarDelegate {

}

extension MoviesViewController: UITableViewDelegate {

}

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}

