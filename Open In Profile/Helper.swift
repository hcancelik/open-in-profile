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
    static func openLink(url: String, rules: [RuleViewModel]) {
        let commandPath = UserDefaults.standard.string(forKey: "ChromePath") ?? "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
        let defaultProfileDirectory = UserDefaults.standard.string(forKey: "ChromeProfile") ?? "Default"
        var profileDirectory = defaultProfileDirectory
        
        for rule in rules {
            if url.contains(rule.criteria) {
                profileDirectory = rule.profile
                
                break
            }
        }
        
        if profileDirectory == "Safari" {
            do {
                let siteURL = URL(string: url)!
                
                let safariURL = try FileManager.default.url(for: .applicationDirectory, in: .localDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Safari.app")
                NSWorkspace.shared.open([siteURL], withApplicationAt: safariURL, configuration: .init()) { (runningApp, error) in
                    print("running app", runningApp ?? "nil")
                }
                
                return
            } catch {
                print(error)
            }
        }
        
        
        let directoryArg = "--profile-directory=\(profileDirectory)"
        let arguments = ["--args", directoryArg, url]
        
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
    
    static func getBundleVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    static func checkIfUpdateAvailable() -> Bool {
        let currentVersion = Helper.getBundleVersion()
        
        if currentVersion != "" {
            if let url = URL(string: "https://hikmetcancelik.com/open-in-profile/version.txt") {
                do {
                    var version = try String(contentsOf: url).trimmingCharacters(in: CharacterSet.newlines)
                    
                    if version.contains("Version:") {
                        version = version.replacingOccurrences(of: "Version:", with: "")
                        
                        UserDefaults.standard.set(version, forKey: "LatestVersion")
                        
                        if version != Helper.getBundleVersion() {
                            UserDefaults.standard.set(true, forKey: "UpdatesAvailable")
                            
                            return true
                        }
                    }
                } catch {
                    UserDefaults.standard.set(false, forKey: "UpdatesAvailable")
                    
                    return false
                }
            }
        }
        
        UserDefaults.standard.set(false, forKey: "UpdatesAvailable")
        
        return false
    }
    
    static func checkIfUserShouldAlertedForAvailableUpdate() -> Bool {
        let currentVersion = Helper.getBundleVersion()
        let latestVersion = UserDefaults.standard.string(forKey: "LatestVersion") ?? currentVersion
        
        if latestVersion != currentVersion {
            let lastNotificationVersion = UserDefaults.standard.string(forKey: "LastNotifedVersion") ?? ""
            
            if lastNotificationVersion != latestVersion {
                return true
            }
        }
        
        return false
    }
    
    static func markUpdateNotificationAsRead() -> Void {
        let latestVersion = UserDefaults.standard.string(forKey: "LatestVersion")
        
        UserDefaults.standard.set(latestVersion, forKey: "LastNotifedVersion")
    }
    
    static func goToWebPage(url: String = "https://hikmetcancelik.com/open-in-profile/") -> Void {
        Helper.openLink(url: url, rules: [])
    }
    
    static func resetAllUserDefaults() -> Void {
        let domain = Bundle.main.bundleIdentifier!
        
        UserDefaults.standard.removePersistentDomain(forName: domain)
        
        UserDefaults.standard.synchronize()
        
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }
}
