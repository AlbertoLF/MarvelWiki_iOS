//
//  APIError.swift
//  MarvelWiki
//
//  Created by Alberto Luque Fernández on 13/1/22.
//

import Foundation

enum APIError: Error {
    case decoding
    case encoding
    case badRequest(error: MarvelAPIError)
    case server(error: String)
    case unknown(error: String?)
}

struct MarvelAPIError: Codable {
    let code: String
    let message: String
}
