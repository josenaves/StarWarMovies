//
//  DataProvider.swift
//  StarWarsMovies
//
//  Created by José Naves Moura Neto on 19/05/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import CoreData

let dataErrorDomain = "dataErrorDomain"

enum DataErrorCode: NSInteger {
    case networkUnavailable = 1001
    case wrongDataFormat = 1002
}

class DataProvider {
    
    private let persistentContainer: NSPersistentContainer
    private let api: StarWarsApi
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer, api: StarWarsApi) {
        self.persistentContainer = persistentContainer
        self.api = api
    }
    
    func fetchMovies(completion: @escaping(Error?) -> Void) {
        api.getMovies() { jsonDictionary, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let jsonDictionary = jsonDictionary else {
                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                completion(error)
                return
            }
            
            let taskContext = self.persistentContainer.newBackgroundContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.undoManager = nil
            
            _ = self.syncMovies(jsonDictionary: jsonDictionary, taskContext: taskContext)
            
            completion(nil)
        }
    }
    
    private func syncMovies(jsonDictionary: [[String: Any]], taskContext: NSManagedObjectContext) -> Bool {
        var successfull = false
        taskContext.performAndWait {
            let matchingEpisodeRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
            let episodeIds = jsonDictionary.map { $0["episode_id"] as? Int }.compactMap { $0 }
            matchingEpisodeRequest.predicate = NSPredicate(format: "episodeId in %@", argumentArray: [episodeIds])
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingEpisodeRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            
            // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                
                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.persistentContainer.viewContext])
                }
            } catch {
                print("Error: \(error)\nCould not batch delete existing records.")
                return
            }
            
            // Create new records.
            for movieDictionary in jsonDictionary {
                
                guard let movie = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: taskContext) as? Movie else {
                    print("Error: Failed to create a new Movie object!")
                    return
                }
                
                do {
                    try movie.update(with: movieDictionary)
                } catch {
                    print("Error: \(error)\nThe movie object will be deleted.")
                    taskContext.delete(movie)
                }
            }
            
            // Save all the changes
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                // Reset the context (free resources)
                taskContext.reset()
            }
            successfull = true
        }
        return successfull
    }
}
