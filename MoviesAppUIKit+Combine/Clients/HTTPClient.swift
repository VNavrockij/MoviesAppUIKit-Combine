//
//  HTTPClient.swift
//  MoviesAppUIKit+Combine
//
//  Created by Vitalii Navrotskyi on 06.02.2024.
//

import Foundation
import Combine

protocol HTTPClientProtocol {
    func fetchMovies(search: String) -> AnyPublisher<[Movie], Error>
}

enum NetworkError: Error {
    case badUrl
}

class HTTPClient: HTTPClientProtocol {

    func fetchMovies(search: String) -> AnyPublisher<[Movie], Error> {
        guard let encodedSearch = search.urlEncoding,
              let url =  URL(string: "http://www.omdbapi.com/?s=t\(search)&apikey=9150748b")
        else {
            return Fail(error: NetworkError.badUrl).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.Search)
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<[Movie], Error> in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
