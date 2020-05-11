//
//  LaunchAtLoginHelper.swift
//
//  Updated by H. Can Celik
//  Borrowed from Erica Sadun
//
//  Copyright (c) 2020 H. Can Celik. All rights reserved.

import Foundation

public func willLaunchAtLogin() -> Bool {
    if let itemURL = getUrl() {
        return existingItem(itemURL: itemURL) != nil
    } else {
        return false
    }
}

public func setLaunchAtLogin(enabled: Bool) -> Bool {
    let loginItems_ = getLoginItems()
    
    if loginItems_ == nil {return false}
    
    let loginItems = loginItems_!
    
    if let itemURL = getUrl() {
        let item = existingItem(itemURL: itemURL)
        
        if item != nil && enabled {return true}
        
        if item != nil && !enabled {
            LSSharedFileListItemRemove(loginItems, item)
            return true
        }
        
        LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemBeforeFirst.takeUnretainedValue(), nil, nil, itemURL as CFURL, nil, nil)
        
        return true
    } else {
        return false
    }
}

private func getUrl() -> NSURL? {
    let bundleId = Bundle.main.bundleIdentifier ?? "Unknown"
    
    if let urls = LSCopyApplicationURLsForBundleIdentifier(bundleId as CFString, nil)?.takeRetainedValue() as? [NSURL],
        let url = urls.first {
        return url
    }
    
    return nil
}

private func getLoginItems() -> LSSharedFileList? {
    let allocator : CFAllocator! = CFAllocatorGetDefault().takeUnretainedValue()
    
    let kLoginItems : CFString! = kLSSharedFileListSessionLoginItems.takeUnretainedValue()
    
    var loginItems_ = LSSharedFileListCreate(allocator, kLoginItems, nil)
    
    if loginItems_ == nil {return nil}
    
    let loginItems : LSSharedFileList! = loginItems_?.takeRetainedValue()
    
    return loginItems
}

private func existingItem(itemURL : NSURL) -> LSSharedFileListItem? {
    if let loginItems = getLoginItems() {
        var seed : UInt32 = 0
        
        if let currentItems = LSSharedFileListCopySnapshot(loginItems, &seed).takeRetainedValue() as? NSArray {
            for item in currentItems {
                let resolutionFlags : UInt32 = UInt32(kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes)
                
                if let url = LSSharedFileListItemCopyResolvedURL(item as! LSSharedFileListItem, resolutionFlags, nil).takeRetainedValue() as? NSURL {
                    if url.isEqual(itemURL) {
                        let result = item as! LSSharedFileListItem
                        return result
                    }
                }
            }
        }
    }

    return nil
}
