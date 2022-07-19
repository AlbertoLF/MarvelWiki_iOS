//
//  MarvelResponse.swift
//  MarvelWiki
//

//

import Foundation

protocol MarvelResponse where Self: Decodable {
    
    associatedtype ObjectResponse: Codable
    
    var code: Int { get }
    var status: String { get }
    var data: ObjectResponse? { get }
}
