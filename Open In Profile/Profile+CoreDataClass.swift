//
//  Profile+CoreDataClass.swift
//  Open In Profile
//
//  Created by H. Can Celik on 7/2/22.
//  Copyright © 2022 H. Can Celik. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Profile)
public class Profile: NSManagedObject {
    static var viewContext: NSManagedObjectContext {
        CoreDataManager.shared.persistentContainer.viewContext
    }
    
    static var all: NSFetchRequest<Profile> {
        let request: NSFetchRequest<Profile> = Profile.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "order", ascending: true),
        ]
        
        return request
    }
    
    static func byId<Profile>(id: NSManagedObjectID) -> Profile? {
        viewContext.object(with: id) as? Profile
    }
    
    static func byDirectory(directory: String) -> Profile? {
        let request: NSFetchRequest<Profile> = Profile.fetchRequest()
        
        request.predicate = NSPredicate(format: "directory = %@", directory)
        
        let profile = try? viewContext.fetch(request)
        
        return profile?.first
    }
    
    func save() throws {
        try Self.viewContext.save()
    }
    
    func delete() throws {
        Self.viewContext.delete(self)
        try save()
    }
}
