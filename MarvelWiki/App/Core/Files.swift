//
//  Files.swift
//  MarvelWiki
//

//

import Foundation

func readJSONFile(withName name: String) -> Data? {
    do {
        if let bundle = Bundle.main.path(forResource: name, ofType: "json"),
           let data = try String(contentsOfFile: bundle).data(using: .utf8) {
            return data
        }
    } catch {
        print("Cannot read the JSON file with name: \(name)")
    }
    
    return nil
}

func mapJSONFile<T: Decodable>(withName name: String, object: T.Type) -> T? {
    guard let data = readJSONFile(withName: name) else {
        return nil
    }
    do {
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    } catch {
        print("Cannot decode JSON file with name: \(name) in object of type \(T.self)")
    }
    
    return nil
}
