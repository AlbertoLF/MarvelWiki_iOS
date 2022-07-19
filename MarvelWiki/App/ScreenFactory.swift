//
//  ScreenFactory.swift
//  MarvelWiki
//

//

import Foundation

class ScreenFactory {
    
    static func makeCharacterList(navigationDelegate: CharacterListNavigationDelegate) -> CharacterListViewController {
        let interactor = CharacterInteractor(characterRepository: CharacterRepository.shared)
        let presenter = CharacterListPresenter(navigationDelegate: navigationDelegate, characterInteractor: interactor)
        let viewController = CharacterListViewController(presenter)
        
        presenter.ui = viewController
        
        return viewController
    }
    
    static func makeCharacterDetail(navigationDelegate: CharacterDetailNavigationDelegate, characterIdentifier identifier: Int) -> CharacterDetailViewController {
        let interactor = CharacterInteractor(characterRepository: CharacterRepository.shared)
        let presenter = CharacterDetailPresenter(navigationDelegate: navigationDelegate, characterInteractor: interactor, characterIdentifier: identifier)
        let viewController = CharacterDetailViewController(presenter)
        
        presenter.ui = viewController
        
        return viewController
    }
}
