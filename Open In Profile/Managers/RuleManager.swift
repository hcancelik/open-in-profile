//
//  Rule Manager.swift
//  Open In Profile
//
//  Created by H. Can Celik on 6/29/22.
//  Copyright © 2022 H. Can Celik. All rights reserved.
//

import Foundation
import CoreData

class RuleManager: NSObject, ObservableObject {
    @Published var rules: [RuleViewModel] = []
    
    private let fetchedResultsController: NSFetchedResultsController<Rule>
    private var context: NSManagedObjectContext
    
    override init() {
        self.context = CoreDataManager.shared.persistentContainer.viewContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: Rule.all, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        fetchedResultsController.delegate = self
        
        deleteTrashedRules()
        
        fetchRules()
    }
    
    func newRule() -> Rule {
        let rule = Rule(context: context)
        
        rule.id = UUID()
        rule.criteria = "google.com"
        rule.profile = "Default"
        rule.order = Int64(rules.count + 1)
        
        return rule
    }
    
    subscript(ruleId: RuleViewModel.ID?) -> RuleViewModel {
        get {
            if let id = ruleId {
                if let rule = rules.first(where: { $0.id == id }) {
                    return rule
                }
                
                return RuleViewModel(rule: newRule())
            }
            
            return RuleViewModel(rule: newRule())
        }

        set(newValue) {
            if let index = rules.firstIndex(where: { $0.id == newValue.id }) {
                rules[index] = newValue
            }
        }
    }
    
    func fetchRules() {
        do {
            try fetchedResultsController.performFetch()
            
            guard let rules = fetchedResultsController.fetchedObjects else {
                return
            }
            
            self.rules = rules.map { rule -> RuleViewModel in
                return RuleViewModel(rule: rule)
            }
        } catch {
            print(error)
        }
    }
    
    func addNewRule() {
        let rule = newRule()
        
        do {
            try rule.save()
        } catch {
            print(error)
        }
    }
    
    func updateRule(rule: RuleViewModel) {
        let model: Rule? = Rule.byId(id: rule.objectId)
    
        if let model = model {
            do {
                model.order = rule.order
                model.profile = rule.profile
                model.criteria = rule.criteria
                
                try model.save()
                
                reOrder()
            } catch {
                print(error)
            }
        }
    }
    
    func reOrder() {
        for (index, rule) in rules.enumerated() {
            do {
                let model: Rule? = Rule.byId(id: rule.objectId)
                
                if let model = model {
                    model.order = Int64(index + 1)
                    
                    try model.save()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func deleteRule(_ ruleID: Rule.ID) {
        if let rule = rules.first(where: { $0.id == ruleID }) {
            let model: Rule? = Rule.byId(id: rule.objectId)
            
            if let model = model {
                do {
                    model.isTrashed = true
                    
                    try model.save()
                    
                    reOrder()
                } catch {
                    print(error)
                }
            }
        }
    }

    func deleteTrashedRules() {
        let request = Rule.deletedRules
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for rule in results {
                    try rule.delete()
                }
            }
        } catch {
            print(error)
        }
    }
}

extension RuleManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let rules = controller.fetchedObjects as? [Rule] else {
            return
        }
        
        self.rules = rules.map { rule in
            return RuleViewModel(rule: rule)
        }
    }
}
