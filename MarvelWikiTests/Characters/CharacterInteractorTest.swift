//
//  CharacterInteractorTest.swift
//  MarvelWikiTests
//

//

import XCTest
@testable import MarvelWiki

class CharacterInteractorTest: XCTestCase {

    func testSortCharactersAlphabetically() {
        // GIVEN
        let characterRepository = CharacterRepository()
        let characterInteractor = CharacterInteractor(characterRepository: characterRepository)
        let unsortedCharacters = getUnsortedCharacters()
         
        // WHEN
        let sortedCharactersAlphabetically = characterInteractor.sort(characters: unsortedCharacters, by: .alphabetically)
        
        // THEN
        var lastCharacter: Character?
        for character in sortedCharactersAlphabetically {
            if lastCharacter != nil {
                XCTAssertTrue(lastCharacter?.name ?? "" <= character.name)
            }
            lastCharacter = character
        }
    }

    func testSortCharactersByComics() {
        // GIVEN
        let characterRepository = CharacterRepository()
        let characterInteractor = CharacterInteractor(characterRepository: characterRepository)
        let unsortedCharacters = getUnsortedCharacters()
        
        // WHEN
        let sortedCharacters = characterInteractor.sort(characters: unsortedCharacters, by: .numberOfComics)
        
        // THEN
        var lastCharacter: Character?
        for character in sortedCharacters {
            if lastCharacter != nil {
                XCTAssertTrue(lastCharacter?.comics.available ?? 0 >= character.comics.available)
            }
            lastCharacter = character
        }
    }
    
}

extension CharacterInteractorTest {
    
    func getUnsortedCharacters() -> [Character] {
        [
            Character(identifier: 0, name: "K", desc: nil, thumbnail: Thumbnail(path: "", ext: ""), comics: ComicList(available: 4)),
            Character(identifier: 1, name: "C", desc: nil, thumbnail: Thumbnail(path: "", ext: ""), comics: ComicList(available: 67)),
            Character(identifier: 2, name: "D", desc: nil, thumbnail: Thumbnail(path: "", ext: ""), comics: ComicList(available: 3)),
            Character(identifier: 3, name: "J", desc: nil, thumbnail: Thumbnail(path: "", ext: ""), comics: ComicList(available: 667)),
            Character(identifier: 4, name: "A", desc: nil, thumbnail: Thumbnail(path: "", ext: ""), comics: ComicList(available: 1000)),
            Character(identifier: 5, name: "R", desc: nil, thumbnail: Thumbnail(path: "", ext: ""), comics: ComicList(available: 0)),
            Character(identifier: 6, name: "S", desc: nil, thumbnail: Thumbnail(path: "", ext: ""), comics: ComicList(available: 21)),
            Character(identifier: 7, name: "Q", desc: nil, thumbnail: Thumbnail(path: "", ext: ""), comics: ComicList(available: 9)),
            Character(identifier: 8, name: "Z", desc: nil, thumbnail: Thumbnail(path: "", ext: ""), comics: ComicList(available: 0)),
            Character(identifier: 9, name: "H", desc: nil, thumbnail: Thumbnail(path: "", ext: ""), comics: ComicList(available: 34)),
        ]
    }
}
