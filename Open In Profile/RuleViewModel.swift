//
//  RuleViewModel.swift
//  Open In Profile
//
//  Created by H. Can Celik on 6/30/22.
//  Copyright © 2022 H. Can Celik. All rights reserved.
//

import Foundation
import CoreData

struct RuleViewModel: Identifiable, Equatable, Hashable {
    private let rule: Rule
    
    init(rule: Rule) {
        self.rule = rule
    }
    
    var id: UUID {
        rule.id
    }
    
    var objectId: NSManagedObjectID {
        rule.objectID
    }
    
    var criteria: String {
        get {
            rule.criteria
        }
        set {
            rule.criteria = newValue
        }
    }
    
    var profile: String {
        get {
            rule.profile
        }
        set {
            rule.profile = newValue
        }
    }
    
    var order: Int64 {
        get {
            rule.order
        }
        
        set {
            rule.order = Int64(newValue)
        }
    }
}
