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
    var selectorPopover: NSPopover!
    var statusBarItem: NSStatusItem!
    private var ruleManager = RuleManager()
    private var profileManager = ProfileManager()
    
    let persistentContainer = CoreDataManager.shared.persistentContainer
    
    func application(_ application: NSApplication, open urls: [URL]) {
        let url = urls[0].absoluteString
        
        let selectProfile = UserDefaults.standard.bool(forKey: "selectProfile")
        
        if selectProfile {
            profileManager.selectedURL = url
            
            self.openSelectorPopup(self)
        } else {
            Helper.openLink(url: url, rules: ruleManager.rules)
            
            profileManager.saveLastVisit(url: url)
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        let contentView = ContentView()
            .environment(\.managedObjectContext, persistentContainer.viewContext)
            .environmentObject(ruleManager)
            .environmentObject(profileManager)

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
        
        let selectorView = SelectorView()
            .environmentObject(profileManager)
        
        let selectorPopover = NSPopover()
        selectorPopover.contentSize = NSSize(width: 450, height: 400)
        selectorPopover.behavior = .semitransient
        selectorPopover.contentViewController = NSHostingController(rootView: selectorView)
        self.selectorPopover = selectorPopover
        
        Helper.setAsDefaultBrowser()
        
        let _ = Helper.checkIfUpdateAvailable()
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.closePopover(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                
                NSApp.activate(ignoringOtherApps: true)
                
                self.popover.contentViewController?.view.window?.becomeKey()
            }
        }
    }
    
    @objc func openSelectorPopup(_ send: AnyObject) {
        if let button = self.statusBarItem.button {
            self.selectorPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            
            NSApp.activate(ignoringOtherApps: true)
            
            self.selectorPopover.contentViewController?.view.window?.becomeKey()
        }
    }
    
    func closePopover(_ sender: AnyObject?) {
        self.popover.performClose(sender)
    }
    
    func closeSelectorPopover(_ sender: AnyObject?) {
        self.selectorPopover.performClose(sender)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        self.closePopover(self)
        self.closeSelectorPopover(self)
    }
}

