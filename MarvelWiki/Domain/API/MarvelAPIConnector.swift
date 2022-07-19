//
//  MarvelAPIConnector.swift
//  MarvelWiki
//
//  Created by Alberto Luque Fernández on 14/1/22.
//

import Foundation

class MarvelAPIConnector: APIConnector {
    
    // MARK: Singleton
    
    static let shared: MarvelAPIConnector = .init()
    
    // MARK: Private init
    
    private init() {}
 
    // MARK: API Connector functions
    
    func execute<T>(_ request: APIRequest, responseType: T.Type) async -> Result<T, Error> where T : Decodable {
        
        guard let urlRequest = try? convertToURLRequest(request) else {
            return .failure(APIError.unknown(error: "Error trying to convert APIRequest to URLRequest"))
        }
        return await withCheckedContinuation { (continuation: CheckedContinuation<Result<T, Error>, Never>) in
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                do {
                    if let error = error {
                        continuation.resume(returning: .failure(error))
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        switch httpResponse.statusCode {
                            case 200..<300:
                                print("Request status code: \(httpResponse.statusCode) - OK")
                                
                                guard let data = data else {
                                    preconditionFailure("No Data.")
                                }
                                
                                let decoder = JSONDecoder()
                                let decodedObject = try decoder.decode(T.self, from: data)
                                
                                continuation.resume(returning: .success(decodedObject))
                                
                            case 400..<500:
                                print("Request status code: \(httpResponse.statusCode) - Bad Request")
                                
                                guard let data = data else {
                                    preconditionFailure("No Data.")
                                }
                                
                                let decoder = JSONDecoder()
                                let decodedError = try decoder.decode(MarvelAPIError.self, from: data)
                                
                                continuation.resume(returning: .failure(APIError.badRequest(error: decodedError)))
                                
                            case 500..<1000:
                                print("Request status code: \(httpResponse.statusCode) - Server Error")
                                
                                guard let error = error else {
                                    continuation.resume(returning: .failure(APIError.unknown(error: nil)))
                                    return
                                }
                                
                                continuation.resume(returning: .failure(APIError.server(error: error.localizedDescription)))
                                
                            default:
                                guard let error = error else {
                                    continuation.resume(returning: .failure(APIError.unknown(error: nil)))
                                    return
                                }
                                continuation.resume(returning: .failure(APIError.unknown(error: error.localizedDescription)))
                        }
                    }
                    
                    
                } catch let error as DecodingError {
                    print(error)
                    print("Hay un error al mapear el json con el objeto \(T.self).")
                    continuation.resume(returning: .failure(APIError.decoding))
                    
                } catch let error {
                    continuation.resume(returning: .failure(error))
                }
            }
            .resume()
        }
    }
    
    // MARK: Private Functions
    
    private func convertToURLRequest(_ apiRequest: APIRequest) throws -> URLRequest? {
        let urlString = MarvelAPI.BaseURL + apiRequest.path
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        
        if let parameters = apiRequest.parameters {
            switch parameters {
                case .body(let encodableObject):
                    if let encodableObject = encodableObject {
                        let body = try encodableObject.toJSONData()
                        request.httpBody = body
                        var parameters: [String: String] = [:]
                        addMarvelParameters(toParameters: &parameters)
                        
                        let query_params = parameters.compactMap({ (element) -> URLQueryItem? in
                            return URLQueryItem(name: element.key, value: element.value)
                        })
                        
                        guard var components = URLComponents(string: urlString) else {
                            throw APIError.encoding
                        }
                        
                        components.queryItems = query_params
                        request.url = components.url
                        
                    } else {
                        throw APIError.encoding
                    }
                    
                case .url(let urlParameters):
                    if var parameters = urlParameters {
                        addMarvelParameters(toParameters: &parameters)
                        
                        let query_params = parameters.compactMap({ (element) -> URLQueryItem? in
                            return URLQueryItem(name: element.key, value: element.value)
                        })
                        
                        guard var components = URLComponents(string: urlString) else {
                            throw APIError.encoding
                        }
                        
                        components.queryItems = query_params
                        request.url = components.url
                        
                    } else {
                        throw APIError.encoding
                    }
            }
            
        }
        
        
        return request
    }
    
    private func getMarvelAPIConfiguration() -> MarvelAPIConfiguration? {
        guard let data = mapJSONFile(withName: "APIConfiguration", object: MarvelAPIConfiguration.self) else {
            return nil
        }
        return data
    }
    
    private func addMarvelParameters(toParameters parameters: inout [String: String]) {
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

// MARK: - Encodable Extension

fileprivate extension Encodable {
    func toJSONData() throws -> Data? {
        try JSONEncoder().encode(self)
    }
}
