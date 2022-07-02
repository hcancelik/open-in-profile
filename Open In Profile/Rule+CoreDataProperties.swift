//
//  Rule+CoreDataProperties.swift
//  Open In Profile
//
//  Created by H. Can Celik on 6/29/22.
//  Copyright © 2022 H. Can Celik. All rights reserved.
//
//

import Foundation
import CoreData


extension Rule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rule> {
        return NSFetchRequest<Rule>(entityName: "Rule")
    }

    @NSManaged public var id: UUID
    @NSManaged public var criteria: String
    @NSManaged public var profile: String
    @NSManaged public var order: Int64
    @NSManaged public var isTrashed: Bool

}

extension Rule : Identifiable {

}
