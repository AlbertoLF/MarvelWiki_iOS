//  
//  CharacterDetailPresenterProtocol.swift
//  MarvelWiki
//


import UIKit

enum CharacterDetailNavigation {
    
}

protocol CharacterDetailNavigationDelegate: AnyObject {
    func handle(_ navigation: CharacterDetailNavigation)
}

protocol CharacterDetailPresenterProtocol where Self: BasePresenter {
    
    var model: CharacterDetailViewController.Model { get set }
    
}
