//  
//  CharacterListPresenter.swift
//  MarvelWiki
//


import UIKit

class CharacterListPresenter: BasePresenter, CharacterListPresenterProtocol {
    
    // MARK: - Properties
    
    private weak var navigationDelegate: CharacterListNavigationDelegate?
    
    private let characterInteractor: CharacterInteractorProtocol
    
    weak var ui: CharacterListViewDelegate?
    
    var characters: [Character] = []
    
    var hasMoreResults: Bool = true
    
    var charactersSelectedOrder: CharactersOrder = .alphabetically
    
    private var lastFetchText: String?
    
    // MARK: - Initialization
    
    init(navigationDelegate: CharacterListNavigationDelegate, characterInteractor: CharacterInteractorProtocol) {
        self.navigationDelegate = navigationDelegate
        self.characterInteractor = characterInteractor
    }
    
    // MARK: - CharacterListPresenter Functions
    
    func viewDidLoad() {
        ui?.showLoading(true)
        getCharacters(with: nil)
    }
    
    func getCharacters(with text: String?) {
        if lastFetchText == text, !hasMoreResults {
            return
        }
        lastFetchText = text
        Task {
            if text?.isEmpty == false {
                await fetch(text: text)
            } else {
                await fetch(text: nil)
            }
        }
    }
    
    func selectCharactersOrder(_ order: CharactersOrder) {
        guard charactersSelectedOrder != order else { return }
        charactersSelectedOrder = order
        sortAndRenderCharacters()
    }
}

// MARK: - Private functions
    
extension CharacterListPresenter {
    
    private func fetch(text: String?) async {
        ui?.showLoading(true)
        let result = await characterInteractor.fetch(text: text)
        switch result {
        case .success((let characters, let hasMoreResults)):
            if characters.isEmpty {
                ui?.showNoResults()
            } else {
                self.hasMoreResults = hasMoreResults
                self.characters = characters
                self.sortAndRenderCharacters()                
            }
                
        case .failure(let error):
            ui?.showError(text: error.localizedDescription)
        }
        ui?.showLoading(false)
    }
    
    private func getModel(from characters: [Character]) -> [CharacterListView.Model] {
        let charactersViewModel: [CharacterListView.Model] = characters.map { character in
                .init(name: character.name,
                      imageURL: character.thumbnail.completeUrl,
                      action: { [weak self] in
                    guard let self = self else { return }
                    self.navigateToDetail(characterIdentifier: character.identifier)
                })
        }
        return charactersViewModel
    }
    
    private func navigateToDetail(characterIdentifier identifier: Int) {
        navigationDelegate?.handle(.detail(identifier: identifier))
    }
    
    private func sortAndRenderCharacters() {
        let sortedCharacters = characterInteractor.sort(characters: characters, by: charactersSelectedOrder)
        let model = getModel(from: sortedCharacters)
        ui?.refresh(withModel: model)
    }
}
