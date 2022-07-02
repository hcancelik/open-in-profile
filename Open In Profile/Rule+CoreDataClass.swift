//
//  Rule+CoreDataClass.swift
//  Open In Profile
//
//  Created by H. Can Celik on 6/29/22.
//  Copyright © 2022 H. Can Celik. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Rule)
public class Rule: NSManagedObject {
    static var viewContext: NSManagedObjectContext {
        CoreDataManager.shared.persistentContainer.viewContext
    }
    
    static var all: NSFetchRequest<Rule> {
        let request: NSFetchRequest<Rule> = Rule.fetchRequest()
        
        request.predicate = NSPredicate(format: "isTrashed == NO")
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "order", ascending: true),
        ]
        
        return request
    }
    
    static func byId<Rule>(id: NSManagedObjectID) -> Rule? {
        viewContext.object(with: id) as? Rule
    }
    
    func save() throws {
        try Self.viewContext.save()
    }
    
    func delete() throws {
        Self.viewContext.delete(self)
        try save()
    }
    
    static var deletedRules: NSFetchRequest<Rule> {
        let request: NSFetchRequest<Rule> = Rule.fetchRequest()
        
        request.predicate = NSPredicate(format: "isTrashed == YES")
        
        return request
    }
}
