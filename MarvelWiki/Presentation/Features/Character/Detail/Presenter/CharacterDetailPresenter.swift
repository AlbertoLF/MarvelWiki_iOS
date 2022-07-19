//  
//  CharacterDetailPresenter.swift
//  MarvelWiki
//


import UIKit

class CharacterDetailPresenter: BasePresenter, CharacterDetailPresenterProtocol {
    
    // MARK: - Properties
    
    private weak var navigationDelegate: CharacterDetailNavigationDelegate?
    
    private let characterInteractor: CharacterInteractorProtocol
    
    private let characterIdentifier: Int
    
    weak var ui: CharacterDetailViewDelegate?
    
    var model: CharacterDetailViewController.Model = .init(name: "Character name", numberOfComics: 0)
    
    var character: Character?
    
    // MARK: - Initialization
    
    init(navigationDelegate: CharacterDetailNavigationDelegate, characterInteractor: CharacterInteractorProtocol, characterIdentifier: Int) {
        self.navigationDelegate = navigationDelegate
        self.characterInteractor = characterInteractor
        self.characterIdentifier = characterIdentifier
    }
    
    // MARK: - CharacterDetailPresenter Functions
    
    func viewDidLoad() {
        Task {
            let result = await characterInteractor.getDetail(identifier: characterIdentifier)
            switch result {
            case .success(let character):
                self.character = character
                updateModel()
                ui?.refresh(with: model)
                
            case .failure(let error):
                ui?.showError(error.localizedDescription)
                print("Error at load character.")
            }
        }
    }
}

// MARK: Private functions

extension CharacterDetailPresenter {
    
    private func updateModel() {
        guard let character = character else {
            return
        }

        var description = "There isn't description for this character."
        if let characterDescription = character.desc,
           !characterDescription.isEmpty {
            description = characterDescription
        }
        
        model = .init(name: character.name,
                      imageURL: URL(string: character.thumbnail.completeUrl),
                      description: description,
                      numberOfComics: character.comics.available)
    }
    
}
