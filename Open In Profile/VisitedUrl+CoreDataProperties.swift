//
//  VisitedUrl+CoreDataProperties.swift
//  Open In Profile
//
//  Created by H. Can Celik on 5/10/20.
//  Copyright © 2020 H. Can Celik. All rights reserved.
//
//

import Foundation
import CoreData


extension VisitedUrl {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VisitedUrl> {
        return NSFetchRequest<VisitedUrl>(entityName: "VisitedUrl")
    }

    @NSManaged public var id: UUID
    @NSManaged public var url: String
    @NSManaged public var visitDate: Date

}
