//
//  MovieListViewModel.swift
//  MoviesAppUIKit+Combine
//
//  Created by Vitalii Navrotskyi on 06.02.2024.
//

import Foundation
import Combine

protocol DataSourceProtocol {
    associatedtype Item

    var itemsCount: Int { get }

    func getItemForIndexPath(indexPath: IndexPath) -> Item
}

protocol MovieListViewModelProtocol: DataSourceProtocol where Item == Movie {
    
    var moviesPublisher: Published<[Item]>.Publisher { get }
    var loadingCompletedPublisher: Published<Bool>.Publisher { get }

    func setSearchText(_ searchText: String)
    func loadMovies(search: String)

}

class MovieListViewModel: MovieListViewModelProtocol {
    typealias Item = Movie

    var itemsCount: Int { movies.count }

    func getItemForIndexPath(indexPath: IndexPath) -> Item {
        movies[indexPath.item]
    }

    var moviesPublisher: Published<[Item]>.Publisher { $movies }
    var loadingCompletedPublisher: Published<Bool>.Publisher { $loadingCompleted }

    @Published private var movies: [Item] = []
    @Published private var loadingCompleted: Bool = false

    private var cancellable: Set<AnyCancellable> = []

    private var searchObject = CurrentValueSubject<String, Never>("")

    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
        setupSearchPublisher()
    }

    private func setupSearchPublisher() {
        searchObject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchTest in
                self?.loadMovies(search: searchTest)
            }.store(in: &cancellable)
    }

    func setSearchText(_ searchText: String) {
        searchObject.send(searchText)
    }

    func loadMovies(search: String) {
        httpClient.fetchMovies(search: search)
            .sink { [weak self] compliton in
                switch compliton {
                    case .finished:
                        self?.loadingCompleted = true
                        print("Finish")
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }.store(in: &cancellable)
    }
}
