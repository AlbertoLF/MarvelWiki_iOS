//
//  MarvelAPIConstants.swift
//  MarvelWiki
//

//

import Foundation

class MarvelAPI {
    
    // MARK: Definitions
    
    enum Endpoint {
        static let list = MarvelAPI.baseURL + "/v1/public/characters"
        static let detail = MarvelAPI.baseURL + "/v1/public/characters/"
    
        enum ErrorStatusCode {
            static let success: Int = 200
            static let notFound: Int = 404
            static let invalidParameter: Int = 409
        }
        
    }
    
    // MARK: Constants
    
    static let baseURL = "https://gateway.marvel.com:443"
    
    // MARK: Private functions
    
    private static func getMarvelAPIConfiguration() -> MarvelAPIConfiguration? {
        guard let data = mapJSONFile(withName: "APIConfiguration", object: MarvelAPIConfiguration.self) else {
            return nil
        }
        return data
    }
    
    // MARK: Public functions
    
    static func addMarvelParameters(toParameters parameters: inout [String: String]) {
        guard let marvelAPIConfiguration = getMarvelAPIConfiguration() else {
            print("Cannot find Marvel API Configuration.")
            return
        }
        
        let timestamp = Date().timeIntervalSince1970.description
        parameters["ts"] = timestamp
        parameters["apikey"] = marvelAPIConfiguration.publicKey
        let privateKey = marvelAPIConfiguration.privateKey
        let publicKey = marvelAPIConfiguration.publicKey
        let hash = "\(timestamp)\(privateKey)\(publicKey)"
        parameters["hash"] = hash.md5()
    }
    
}
