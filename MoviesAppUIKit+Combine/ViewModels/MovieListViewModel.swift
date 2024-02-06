//
//  MovieListViewModel.swift
//  MoviesAppUIKit+Combine
//
//  Created by Vitalii Navrotskyi on 06.02.2024.
//

import Foundation
import Combine

class MovieListViewModel {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var loadingCompleted: Bool = false
    private var cancellable: Set<AnyCancellable> = []

    private let httpClient: HTTPClient

    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    func loadSearch(search: String) {
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
