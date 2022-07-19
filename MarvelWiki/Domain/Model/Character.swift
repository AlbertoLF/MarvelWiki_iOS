//
//  Character.swift
//  MarvelWiki
//

//

import Foundation

struct CharacterResponse: Codable, MarvelResponse {
    let code: Int
    let status: String
    let data: CharacterDataResponse?
}

struct CharacterDataResponse: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [Character]
}

struct Character: Codable, Hashable, Equatable {
    
    let identifier: Int
    let name: String
    var desc: String?
    let thumbnail: Thumbnail
    let comics: ComicList
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case desc = "description"
        case thumbnail
        case comics
    }
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

struct Thumbnail: Codable {
    let path: String
    let ext: String
    
    var completeUrl: String {
        "\(path).\(ext)"
    }
    
    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
}

struct ComicList: Codable {
    var available: Int
}
