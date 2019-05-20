//
//  Movie.swift
//  StarWarsMovies
//
//  Created by José Naves Moura Neto on 19/05/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import CoreData

class Movie: NSManagedObject {
    
    @NSManaged var title: String
    @NSManaged var director: String
    @NSManaged var producer: String
    @NSManaged var openingCrawl: String
    @NSManaged var episodeId: NSNumber
    @NSManaged var releaseDate: Date

    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
    }()
    
    func update(with jsonDictionary: [String: Any]) throws {
        
        guard let title = jsonDictionary["title"] as? String,
            let director = jsonDictionary["director"] as? String,
            let producer = jsonDictionary["producer"] as? String,
            let openingCrawl = jsonDictionary["opening_crawl"] as? String,
            let episodeId = jsonDictionary["episode_id"] as? Int,
            let releaseDate = jsonDictionary["release_date"] as? String
            else {
                throw NSError(domain: "", code: 1000, userInfo: nil)
            }
        
        self.title = title
        self.director = director
        self.producer = producer
        self.openingCrawl = openingCrawl
        self.episodeId = NSNumber(value: episodeId)
        self.releaseDate = Movie.dateFormatter.date(from: releaseDate) ?? Date(timeIntervalSince1970: 0)
    }
}
