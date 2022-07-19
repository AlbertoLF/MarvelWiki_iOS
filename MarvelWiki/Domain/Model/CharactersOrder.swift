//
//  CharactersOrder.swift
//  MarvelWiki
//

//

import Foundation

enum CharactersOrder: CaseIterable {
    case alphabetically
    case numberOfComics
    
    var textToShow: String {
        switch self {
        case .alphabetically:
            return "Alphabetically"
        case .numberOfComics:
            return "Number of comics"
        }
    }
}
