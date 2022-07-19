//  
//  CharacterRepositoryProtocol.swift
//  MarvelWiki
//


import Foundation

protocol CharacterRepositoryProtocol {
    
    var charactersCache: Set<Character> { get set }
    
    func fetch(nameStartsWith: String?) async -> Result<(characters: [Character], hasMoreResults: Bool), Error>
    
    func getDetail(identifier: Int) async -> Result<Character, Error>
    
    func clearCache()
    
}
