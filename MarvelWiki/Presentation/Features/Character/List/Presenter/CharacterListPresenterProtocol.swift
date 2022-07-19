//  
//  CharacterListPresenterProtocol.swift
//  MarvelWiki
//


import UIKit

enum CharacterListNavigation {
    case detail(identifier: Int)
}

protocol CharacterListNavigationDelegate: AnyObject {
    func handle(_ navigation: CharacterListNavigation)
}

protocol CharacterListPresenterProtocol where Self: BasePresenter {
    
    var hasMoreResults: Bool { get set }
    
    var charactersSelectedOrder: CharactersOrder { get set }
    
    func getCharacters(with text: String?)
    
    func selectCharactersOrder(_ order: CharactersOrder)
    
}
