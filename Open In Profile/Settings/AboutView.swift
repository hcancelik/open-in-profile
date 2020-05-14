//
//  AboutView.swift
//  Open In Profile
//
//  Created by H. Can Celik on 5/13/20.
//  Copyright © 2020 H. Can Celik. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    let version = Helper.getBundleVersion()
    @State private var updateAvailable = false
    @State private var checkUpdateButtonText = "Check for a new version"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Current Version: \(version)")
                .onAppear {
                    self.updateAvailable = UserDefaults.standard.bool(forKey: "UpdatesAvailable")
                    self.checkUpdateButtonText = "Check for a new version"
                }
            
            if(self.updateAvailable) {
                Button(action: {
                    Helper.goToWebPage()
                }) {
                    Text("There is a new version avilable!")
                        .padding(.horizontal, 8)
                        .padding(.vertical, 10)
                }
                .buttonStyle(CustomButtonStyle(bgColor: Color("Green-500"), txtColor: .white))
            } else {
                Button(action: {
                    let available = Helper.checkIfUpdateAvailable()
                    
                    if(!available) {
                        self.checkUpdateButtonText = "No new version is available"
                    }
                }) {
                    Text(checkUpdateButtonText)
                }
            }
            
            Text("Open In Profile is created by H. Can Celik.")
            
            HStack {
                Text("If you have any questions or feeback, please check out the website.")
                
                Button(action: {
                    Helper.goToWebPage()
                }) {
                    Image(nsImage: NSImage(named: NSImage.followLinkFreestandingTemplateName)!)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            
            
            Spacer()
        }
        .padding()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
