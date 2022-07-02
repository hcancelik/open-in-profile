//
//  SettingsView.swift
//  Open In Profile
//
//  Created by H. Can Celik on 5/9/20.
//  Copyright © 2020 H. Can Celik. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var ruleManager: RuleManager
    @EnvironmentObject var profileManager: ProfileManager
    @State var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: self.$selectedTab) {
            GeneralSettingsView(profileManager: profileManager)
            .tabItem {
                Text("General")
            }
            .tag(0)
            
            ProfilesView(profileManager: profileManager)
            .tabItem {
                Text("Profiles")
            }
            .tag(1)
            
            RulesView(ruleManager: ruleManager, profileManager: profileManager)
            .tabItem {
                Text("Rules")
            }
            .tag(2)
            
            ResetSettingsView()
            .tabItem {
                Text("Reset")
            }
            .tag(3)
            
            AboutView()
            .tabItem {
                Text("About")
            }
            .tag(4)
            
        }
        .padding(20)
        .frame(width: 550, height: 400)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let ruleManager = RuleManager()
        
        SettingsView()
            .environmentObject(ruleManager)
    }
}
