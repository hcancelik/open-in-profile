//
//  ProfileManager.swift
//  Open In Profile
//
//  Created by H. Can Celik on 7/2/22.
//  Copyright © 2022 H. Can Celik. All rights reserved.
//

import Foundation
import CoreData

class ProfileManager: NSObject, ObservableObject {
    @Published var selectedURL: String?
    
    @Published var profiles: [ProfileViewModel] = []
    
    private let fetchedResultsController: NSFetchedResultsController<Profile>
    private var context: NSManagedObjectContext
    
    override init() {
        self.context = CoreDataManager.shared.persistentContainer.viewContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: Profile.all, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        fetchedResultsController.delegate = self
        
        checkDefaultDirectory()
        
        fetchProfiles()
        
        saveExistingProfiles()
    }
    
    func saveLastVisit(url: String) {
        let visitedUrl = VisitedUrl(context: context)
        visitedUrl.id = UUID()
        visitedUrl.url = url
        visitedUrl.visitDate = Date()
        
        try? context.save()
        
        do {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "VisitedUrl")
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "visitDate", ascending: true)]
            
            let results = try context.fetch(fetchRequest)
            
            if results.count > 10 {
                let item = results[0] as! NSManagedObject
                
                context.delete(item)
            }
        } catch {
            print("Error deleting records")
        }
    }
    
    func saveExistingProfiles() {
        let checkRun = UserDefaults.standard.bool(forKey: "convert-existing-profiles")
        
        if !checkRun {
            if let defaultProfile = UserDefaults.standard.string(forKey: "ChromeProfile") {
                if defaultProfile != "Default" && defaultProfile != "Safari" {
                    let profile: Profile = newProfile()
                    
                    profile.label = defaultProfile
                    profile.directory = defaultProfile
                    profile.order = Int64(profiles.count + 1)
                    
                    do {
                        try profile.save()
                    } catch {
                        print(error)
                    }
                }
            }
            
            UserDefaults.standard.set(true, forKey: "convert-existing-profiles")
        }
    }
    
    func checkDefaultDirectory() {
        let profile: Profile? = Profile.byDirectory(directory: "Default")
        
        if profile == nil {
            let newProfile = newProfile()
            newProfile.label = "Default"
            newProfile.directory = "Default"
            
            do {
                try newProfile.save()
            } catch {
                print(error)
            }
        }
        
        let safari: Profile? = Profile.byDirectory(directory: "Safari")
        
        if safari == nil {
            let newProfile = newProfile()
            newProfile.label = "Safari"
            newProfile.directory = "Safari"
            
            do {
                try newProfile.save()
            } catch {
                print(error)
            }
        }
    }
    
    subscript(profileId: ProfileViewModel.ID?) -> ProfileViewModel {
        get {
            if let id = profileId {
                if let profile = profiles.first(where: { $0.id == id }) {
                    return profile
                }
            }
            
            return ProfileViewModel(profile: newProfile())
        }

        set(newValue) {
            if let index = profiles.firstIndex(where: { $0.id == newValue.id }) {
                profiles[index] = newValue
            }
        }
    }
    
    func newProfile() -> Profile {
        let profile = Profile(context: context)
        
        profile.label = "New Profile"
        profile.directory = "Chrome Directory \(UUID().uuidString)"
        profile.order = Int64(profiles.count + 1)
        
        return profile
    }
    
    func fetchProfiles() {
        do {
            try fetchedResultsController.performFetch()
            
            guard let profiles = fetchedResultsController.fetchedObjects else {
                return
            }
            
            self.profiles = profiles.map { profile -> ProfileViewModel in
                return ProfileViewModel(profile: profile)
            }
        } catch {
            print(error)
        }
    }
    
    func addProfile() {
        let profile = newProfile()
        
        do {
            try profile.save()
        } catch {
            print(error)
        }
    }
    
    func updateProfile(profile: ProfileViewModel) {
        let model: Profile? = Profile.byId(id: profile.id)
    
        if let model = model {
            do {
                model.label = profile.label
                model.directory = profile.directory
                model.order = profile.order
                
                try model.save()
                
                reOrder()
            } catch {
                print(error)
            }
        }
    }
    
    func reOrder() {
        for (index, profile) in profiles.enumerated() {
            do {
                let model: Profile? = Profile.byId(id: profile.id)
                
                if let model = model {
                    model.order = Int64(index + 1)
                    
                    try model.save()
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    func deleteProfile(id: NSManagedObjectID) {
        let model: Profile? = Profile.byId(id: id)
        if let model = model {
            let directory = model.directory
            
            do {
                try model.delete()
                
                reOrder()
                
                let rules = Rule.byProfile(profile: directory)
                
                if let rules = rules {
                    for rule in rules {
                        rule.profile = "Default"
                        
                        try rule.save()
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}

extension ProfileManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let profiles = controller.fetchedObjects as? [Profile] else {
            return
        }
        
        self.profiles = profiles.map { profile in
            return ProfileViewModel(profile: profile)
        }
    }
}

