//
//  StarWarsApi.swift
//  StarWarsMovies
//
//  Created by José Naves Moura Neto on 19/05/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import Foundation
import CoreData

class StarWarsApi {
    
    private init() {}
    static let shared = StarWarsApi()
    
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://swapi.co/api/")!
    
    func getMovies(completion: @escaping(_ filmsDict: [[String: Any]]?, _ error: Error?) -> ()) {
        let movieURL = baseURL.appendingPathComponent("films")
        urlSession.dataTask(with: movieURL) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                completion(nil, error)
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDictionary = jsonObject as? [String: Any], let result = jsonDictionary["results"] as? [[String: Any]] else {
                    throw NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                }
                completion(result, nil)
            } catch {
                completion(nil, error)
            }
            
        }.resume()
    
    }
}
