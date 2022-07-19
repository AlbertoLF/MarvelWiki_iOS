//  
//  CharacterInteractor.swift
//  MarvelWiki
//


import Foundation

class CharacterInteractor: CharacterInteractorProtocol {
    
    // MARK: - Properties
    
    private let characterRepository: CharacterRepositoryProtocol
    
    // MARK: - Init
    
    init(characterRepository: CharacterRepositoryProtocol) {
        self.characterRepository = characterRepository
    }
    
    // MARK: - CharacterInteractor functions
    
    func fetch(text: String?) async -> Result<(characters: [Character], hasMoreResults: Bool), Error> {
        let result = await characterRepository.fetch(nameStartsWith: text)
        switch result {
        case .success((let characters, let hasMoreResults)):
            return .success((characters: characters, hasMoreResults: hasMoreResults))
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func sort(characters: [Character], by order: CharactersOrder) -> [Character] {
        switch order {
        case .alphabetically:
            return orderAlphabetically(characters: characters)
        case .numberOfComics:
            return sortCharactersByNumberOfComics(characters)
        }
    }
    
    func getDetail(identifier: Int) async -> Result<Character, Error> {
        await characterRepository.getDetail(identifier: identifier)
    }
}

// MARK: - Private functions

extension CharacterInteractor {
    
    private func orderAlphabetically(characters: [Character], ascendant: Bool = true) -> [Character] {
        characters.sorted(by: { e1, e2 in
            if ascendant {
                return e1.name < e2.name
            } else {
                return e1.name > e2.name
            }
        })
    }
    
    private func sortCharactersByNumberOfComics(_ characters: [Character]) -> [Character] {
        return characters.sorted { firstCharacter, secondCharacter in
            return firstCharacter.comics.available >= secondCharacter.comics.available
        }
    }
}
