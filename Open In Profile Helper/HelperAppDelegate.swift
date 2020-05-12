//
//  AppDelegate.swift
//  Open In Profile Helper
//
//  Created by H. Can Celik on 5/12/20.
//  Copyright © 2020 H. Can Celik. All rights reserved.
//

import Cocoa

@NSApplicationMain
class HelperAppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let runningApps = NSWorkspace.shared.runningApplications
        
        let isRunning = runningApps.contains {
            $0.bundleIdentifier == "com.hcancelik.Open-In-Profile"
        }
        
        if !isRunning {
            var path = Bundle.main.bundlePath as NSString
            
            for _ in 1...4 {
                path = path.deletingLastPathComponent as NSString
            }
            
            NSWorkspace.shared.launchApplication(path as String)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

