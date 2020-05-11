//
//  SettingsView.swift
//  Open In Profile
//
//  Created by H. Can Celik on 5/9/20.
//  Copyright © 2020 H. Can Celik. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: self.$selectedTab) {
            GeneralSettingsView()
            .tabItem {
                Text("General")
                    .font(.headline)
            }
            .tag(0)
            
            VStack {
                Text("This feature is coming soon!")
                .padding(20)
            }
            .tabItem {
                Text("Rules")
            }
            .tag(1)
            
            ResetSettingsView()
            .tabItem {
                Text("Reset")
            }
            .tag(2)
            
        }
        .padding(20)
        .frame(width: 550, height: 400)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
