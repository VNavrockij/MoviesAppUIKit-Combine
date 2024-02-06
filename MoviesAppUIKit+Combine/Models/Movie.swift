//
//  Movie.swift
//  MoviesAppUIKit+Combine
//
//  Created by Vitalii Navrotskyi on 06.02.2024.
//

import Foundation

struct MovieResponse: Decodable {
    let Search: [Movie]
}

struct Movie: Decodable {
    let title: String
    let year: String

    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
    }
}
