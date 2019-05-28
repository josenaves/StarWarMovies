//
//  AppDelegate.swift
//  StarWarsMovies
//
//  Created by José Naves Moura Neto on 19/05/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit
import CoreData

var vSpinner: UIView?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var coreDataStack = CoreDataStack.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootViewController = window?.rootViewController as? UINavigationController
        let listViewController = rootViewController?.topViewController as? MovieListViewController
        
        listViewController?.dataProvider = DataProvider(persistentContainer: coreDataStack.persistentContainer, api: StarWarsApi.shared)
        
        return true
    }
}

