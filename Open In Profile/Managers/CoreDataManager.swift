//
//  CoreDataManager.swift
//  Open In Profile
//
//  Created by H. Can Celik on 6/29/22.
//  Copyright © 2022 H. Can Celik. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    
    static let shared = CoreDataManager()
    
    private init () {
        persistentContainer = NSPersistentContainer(name: "Open_In_Profile")
        persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        persistentContainer.loadPersistentStores { desription, error in
            if let error = error {
                fatalError("Unable to Initialize Core Data: \(error)")
            }
        }
    }
}
