//
//  ProfileViewModel.swift
//  Open In Profile
//
//  Created by H. Can Celik on 7/2/22.
//  Copyright © 2022 H. Can Celik. All rights reserved.
//

import Foundation
import CoreData

struct ProfileViewModel: Identifiable, Hashable, Equatable {
    private let profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
    }
    
    var id: NSManagedObjectID {
        profile.objectID
    }
    
    var directory: String {
        get {
            profile.directory
        }
        
        set {
            profile.directory = newValue
        }
    }
    
    var label: String {
        get {
            profile.label
        }
        
        set {
            profile.label = newValue
        }
    }
    
    var order: Int64 {
        get {
            profile.order
        }
        
        set {
            profile.order = Int64(newValue)
        }
    }
}
