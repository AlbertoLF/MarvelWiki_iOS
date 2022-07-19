//
//  APIError.swift
//  MarvelWiki
//

//

import Foundation

enum APIError: Error {
    case unknown(error: String?)
}

struct MarvelAPIError: Error, Codable, LocalizedError {
    let code: String
    let message: String
    
    init(code: Int, message: String) {
        self.code = "\(code)"
        self.message = message
    }
    
    var errorDescription: String? {
        message
    }
}
