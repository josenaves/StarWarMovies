//
//  CoreDataStack.swift
//  StarWarsMovies
//
//  Created by José Naves Moura Neto on 19/05/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import CoreData

// Singleton classs that exposes NSPersistentContainer
class CoreDataStack {
    
    private init() {}
    
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StarWarsMovies")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("Fatal error: \(error), \(error.userInfo)")
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()

}
