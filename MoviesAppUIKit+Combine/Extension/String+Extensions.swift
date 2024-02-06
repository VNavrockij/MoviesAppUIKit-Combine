//
//  String+Extensions.swift
//  MoviesAppUIKit+Combine
//
//  Created by Vitalii Navrotskyi on 06.02.2024.
//

import Foundation

extension String {
    var urlEncoding: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
