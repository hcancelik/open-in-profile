//
//  Profile+CoreDataProperties.swift
//  Open In Profile
//
//  Created by H. Can Celik on 7/2/22.
//  Copyright © 2022 H. Can Celik. All rights reserved.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var directory: String
    @NSManaged public var label: String
    @NSManaged public var order: Int64

}

extension Profile : Identifiable {

}
