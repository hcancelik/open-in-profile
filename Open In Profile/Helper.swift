//
//  Helper.swift
//  Open In Profile
//
//  Created by H. Can Celik on 4/11/20.
//  Copyright © 2020 H. Can Celik. All rights reserved.
//

import Cocoa
import Foundation

class Helper {
    static func openLink(url: String) {
        let commandPath = UserDefaults.standard.string(forKey: "ChromePath") ?? "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

        let profileDirectory = UserDefaults.standard.string(forKey: "ChromeProfile") ?? "Default"
        let directoryArg = "--profile-directory=\(profileDirectory)"
        let arguments = ["--args", directoryArg, url]
        
//        let commandPath = "/usr/bin/open"
//        let directoryArg = "--profile-directory=Profile 2"
//        let arguments = ["-n", "-a", "Google Chrome", "--args", directoryArg, url]
        
//        let commandPath = "/bin/bash"
//        let arguments = ["-c", "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome", "--args", "--profile-directory=Profile\\ 2", url]

        let processUrl = URL(fileURLWithPath: commandPath)
        try! Process.run(processUrl, arguments: arguments, terminationHandler: nil)
    }
    
    
    static func setAsDefaultBrowser() {
        let bundleId = Helper.getBundleId()
        
        LSSetDefaultHandlerForURLScheme("http" as CFString, bundleId as CFString)
        LSSetDefaultHandlerForURLScheme("https" as CFString, bundleId as CFString)
    }
    
    static func getBundleId() -> String {
        return Bundle.main.bundleIdentifier ?? "Unknown"
    }
}
