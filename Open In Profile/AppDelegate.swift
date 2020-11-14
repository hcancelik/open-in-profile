//
//  AppDelegate.swift
//  Open In Profile
//
//  Created by H. Can Celik on 5/9/20.
//  Copyright © 2020 H. Can Celik. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!

    func application(_ application: NSApplication, open urls: [URL]) {
        let link = urls[0].absoluteString
        
        Helper.openLink(url: link)
        
        let context = persistentContainer.viewContext
        
        let visitedUrl = VisitedUrl(context: context)
        visitedUrl.id = UUID()
        visitedUrl.url = link
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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        let contentView = ContentView().environment(\.managedObjectContext, persistentContainer.viewContext)

        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 500)
        popover.behavior = .semitransient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "Icon")
            button.action = #selector(togglePopover(_:))
        }
        
        Helper.setAsDefaultBrowser()
        
        let _ = Helper.checkIfUpdateAvailable()
    }
    
    func closePopover(_ sender: AnyObject?) {
        self.popover.performClose(sender)
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                
                NSApp.activate(ignoringOtherApps: true)
                
                self.popover.contentViewController?.view.window?.becomeKey()
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        self.closePopover(self)
    }
    

    // MARK: - Core Data stack

    var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Open_In_Profile")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
}

