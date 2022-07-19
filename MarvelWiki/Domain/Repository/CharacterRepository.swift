//  
//  CharacterRepository.swift
//  MarvelWiki
//


import Foundation
import CryptoKit
import Alamofire

class CharacterRepository: CharacterRepositoryProtocol {
    
    static let shared: CharacterRepositoryProtocol = CharacterRepository()
    
    private typealias ErrorStatusCode = MarvelAPI.Endpoint.ErrorStatusCode
    
    private static let charactersPage = 20
    
    // MARK: - Properties
    
    var charactersCache: Set<Character>
    
    var searchCharactersCache: Set<Character>
    
    private var listOffset: Int
    
    private var listLimit: Int
    
    private var lastSearchText: String?
    
    private var searchOffset: Int
    
    private var searchLimit: Int
    
    // MARK: - Init
    
    public init() {
        charactersCache = []
        searchCharactersCache = []
        listOffset = 0
        listLimit = Self.charactersPage
        searchOffset = 0
        searchLimit = Self.charactersPage
    }
    
    // MARK: - CharacterRepositoryProtocol Functions

    /// Fetch 20 characters that name starts with `text`, adds to cache an return all of them. The next time fetch is called it will return the next 20 characters.
    ///
    /// If text is nil, the next 20 characters will be fetched.
    /// You can paginate the search while the `text` parameter is the same.
    ///
    /// - Parameter text: Characters name to search
    /// - Returns: Total characters founded or Errro if exists.
    func fetch(nameStartsWith text: String?) async -> Result<(characters: [Character], hasMoreResults: Bool), Error> {
        let isSearching = text != nil && text?.isEmpty == false
        let parameters = getCharactersFetchParameters(searchText: text, isSearching: isSearching)
        
        let url = MarvelAPI.Endpoint.list
        let task = AF.request(url, parameters: parameters)
        do {
            let response = try await task.serializingDecodable(CharacterResponse.self).value

            switch response.code {
            case ErrorStatusCode.success:
                guard let data = response.data else {
                    return .failure(APIError.unknown(error: "Unknown Error"))
                }
                if isSearching {
                    searchCharactersCache = searchCharactersCache.union(data.results)
                    searchOffset += listLimit
                    let hasMoreResults = searchCharactersCache.count < data.total
                    return .success((Array(searchCharactersCache), hasMoreResults))
                } else {
                    charactersCache = charactersCache.union(data.results)
                    listOffset += listLimit
                    let hasMoreResults = charactersCache.count < data.total
                    return .success((Array(charactersCache), hasMoreResults))
                }

            default:
                return .failure(MarvelAPIError(code: response.code, message: response.status))
            }
            
        } catch let error {
            return .failure(APIError.unknown(error: error.localizedDescription))
        }
    }
    
    func getDetail(identifier: Int) async -> Result<Character, Error> {
        if let character = getFromCache(byIdentifier: identifier) {
            return .success(character)
        } else {
            let url = MarvelAPI.Endpoint.detail + "\(identifier)"
            let task = AF.request(url)
            do {
                let response = try await task.serializingDecodable(CharacterResponse.self).value
                guard let data = response.data,
                      let character = data.results.first
                else {
                    return .failure(MarvelAPIError(code: response.code, message: response.status))
                }
                return .success(character)
                
            } catch let error {
                return .failure(error)
            }
        }
    }
    
    func clearCache() {
        charactersCache.removeAll()
        listOffset = 0
    }
    
}

// MARK: - Private functions

private extension CharacterRepository {
    
    private func getCharactersFetchParameters(searchText text: String?, isSearching: Bool) -> [String: String] {
        let isSearching = text != nil && text?.isEmpty == false
        var requestOffset: Int
        var requestLimit: Int
        
        if isSearching {
            if text != lastSearchText {
                searchOffset = 0
                searchCharactersCache.removeAll()
            }
            lastSearchText = text
            requestOffset = searchOffset
            requestLimit = searchLimit
        } else {
            requestOffset = listOffset
            requestLimit = listLimit
        }
        
        var parameters = [
            "offset": "\(requestOffset)",
            "limit": "\(requestLimit)"
        ]
        if let text = text {
            parameters["nameStartsWith"] = text
        }
        MarvelAPI.addMarvelParameters(toParameters: &parameters)
        
        return parameters
    }
    
    private func getFromCache(byIdentifier identifier: Int) -> Character? {
        charactersCache.first(where: { $0.identifier == identifier })
    }
   
}
