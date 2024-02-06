//
//  MoviesViewController.swift
//  MoviesAppUIKit+Combine
//
//  Created by Vitalii Navrotskyi on 03.02.2024.
//

import UIKit
import SwiftUI
import Combine

// MARK: - MoviesViewController
class MoviesViewController: UIViewController {

    private let viewModel: any MovieListViewModelProtocol
    private var cancellable: Set<AnyCancellable> = []

    init(viewModel: any MovieListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.delegate = self
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

        setupUI()

        viewModel.loadingCompletedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completed in
                if completed {
                    // reload table view
                    self?.moviesTableView.reloadData()
                }
            }.store(in: &cancellable)
    }

// MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white

        moviesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")

        let stackView = UIStackView()
        stackView.axis = .vertical

        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(moviesTableView)

        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

// MARK: - MoviesViewController Extensions
extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.setSearchText(searchText)
    }
}

extension MoviesViewController: UITableViewDelegate {

}

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.itemsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = viewModel.getItemForIndexPath(indexPath: indexPath)

        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = movie.title
        cell.contentConfiguration = content

        return cell
    }

}

// MARK: - MoviesViewControllerRepresentable
struct MoviesViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MoviesViewController

    func updateUIViewController(_ uiViewController: MoviesViewController, context: Context) {
        //
    }
    func makeUIViewController(context: Context) -> MoviesViewController {
        MoviesViewController(viewModel: MovieListViewModel(httpClient: HTTPClient()))
    }
}

#Preview {
    MoviesViewControllerRepresentable()
}
