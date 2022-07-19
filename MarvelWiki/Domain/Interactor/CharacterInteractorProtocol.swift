//  
//  CharacterInteractorProtocol.swift
//  MarvelWiki
//


import Foundation

protocol CharacterInteractorProtocol {
     
    func fetch(text: String?) async -> Result<(characters: [Character], hasMoreResults: Bool), Error>
    
    func sort(characters: [Character], by order: CharactersOrder) -> [Character]
    
    func getDetail(identifier: Int) async -> Result<Character, Error>
    
}
