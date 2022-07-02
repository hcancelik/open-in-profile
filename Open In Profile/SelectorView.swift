//
//  SelectorView.swift
//  Open In Profile
//
//  Created by H. Can Celik on 7/2/22.
//  Copyright © 2022 H. Can Celik. All rights reserved.
//

import SwiftUI

struct SelectorView: View {
    @EnvironmentObject var profileManager: ProfileManager
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let columns = [
       GridItem(.fixed(150)),
       GridItem(.fixed(150)),
       GridItem(.fixed(150)),
   ]
    
    var body: some View {
        VStack {
            Text("Select A Profile")
                .font(.system(size: 20))
                .bold()
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding(.bottom, 15)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(profileManager.profiles) { profile in
                        Button {
                            openUrl(profile: profile.directory)
                        } label: {
                            Text(profile.label)
                                .font(.title2)
                                .frame(width: 130, height: 100)
                        }
                        .buttonStyle(GradientButtonStyle())
                    }
                }
            }
        }
        .padding(25)
        .frame(maxWidth: 475)
        .background(colorScheme == .dark ? .black.opacity(0.8) : .white.opacity(0.8))
    }
    
    
    func openUrl(profile: String) {
        if let url = profileManager.selectedURL {
            Helper.openLink(url: url, rules: [], profile: profile)
            
            profileManager.saveLastVisit(url: url)
        }
    }
}

struct GradientButtonStyle: ButtonStyle {
    @State private var radius = 4.0
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.75), Color.blue]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.7), radius: radius)
            .onHover { hover in
                radius = hover ? 1 : 4
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct SelectorView_Previews: PreviewProvider {
    static var previews: some View {
        SelectorView()
    }
}
