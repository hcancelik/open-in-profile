//
//  GeneralSettingsView.swift
//  Open In Profile
//
//  Created by H. Can Celik on 5/10/20.
//  Copyright © 2020 H. Can Celik. All rights reserved.
//

import SwiftUI
import ServiceManagement

struct GeneralSettingsView: View {
    @ObservedObject var profileManager: ProfileManager
    let helperBundleName = "com.hcancelik.Open-In-Profile-Helper"
    
    @State private var startOnStartUp: Bool = true
    
    @State private var chromePath: String = ""
    @State private var showChromePathSheet: Bool = false
    @State private var showChromeAppInfoPopover: Bool = false
    
    @State private var chromeProfileName: String = ""
    @State private var showChromeProfileSheet: Bool = false
    
    @State private var openBlankUrl: String = ""
    @State private var openBlankUrlSheet: Bool = false
    
    @AppStorage("selectProfile") private var selectProfile = false
    
    var body: some View {
        let launchAtStart = Binding<Bool>(
            get: {
                self.startOnStartUp
            },
                set: {
                    SMLoginItemSetEnabled(self.helperBundleName as CFString, $0)
                    self.startOnStartUp = $0
            }
        )
        
        return VStack {
            VStack {
                HStack(alignment: .top) {
                    Text("Chrome App Location")
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    
                    Button(action: {
                        self.showChromeAppInfoPopover.toggle()
                    }) {
                        Image(systemName: "info.circle")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .popover(isPresented: self.$showChromeAppInfoPopover) {
                        VStack {
                            Text("What is this?")
                                .fontWeight(.black)
                                .padding(.bottom, 20)
                            
                            Text("If you did not install Google Chrome app to Applications folder you should update this field with the correct location.")
                                .frame(width: 250)
                                .padding(.bottom, 20)
                            
                        }
                        .padding(15)
                    }
                    
                    Button(action: {
                        self.showChromePathSheet.toggle()
                    }){
                        Text("Change")
                    }
                    .buttonStyle(LinkButtonStyle())
                    .sheet(isPresented: self.$showChromePathSheet) {
                        VStack {
                            Text("Please provide a path for Chrome Application")
                            
                            TextField("Chrome Path", text: self.$chromePath, onEditingChanged: { _ in
                                self.updateUserDefault(key: "ChromePath", value: self.chromePath)
                            })
                            
                            Spacer().padding(.bottom, 20)
                            
                            HStack {
                                Button(action: {
                                    self.chromePath = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
                                    self.updateUserDefault(key: "ChromePath", value: self.chromePath)
                                    self.showChromePathSheet.toggle()
                                }){
                                    Text("Reset To Default")
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    self.updateUserDefault(key: "ChromePath", value: self.chromePath)
                                    self.showChromePathSheet.toggle()
                                }){
                                    Text("Close")
                                }
                            }
                        }
                        .padding(15)
                        .frame(width: 400)
                    }
                    Spacer()
                }
                
                HStack {
                    Text(self.chromePath)
                        .onAppear{
                            self.chromePath = UserDefaults.standard.string(forKey: "ChromePath") ?? "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
                    }
                    Spacer()
                }
            }
            .padding(.bottom, 15)
            
            VStack {
                HStack(alignment: .top) {
                    Text("Default Chrome Profile Directory")
                        .fontWeight(.bold)
                        .onAppear{
                            self.chromeProfileName = UserDefaults.standard.string(forKey: "ChromeProfile") ?? "Default"
                    }
                                        
                    Button(action: {
                        self.showChromeProfileSheet.toggle()
                    }){
                        Text("Change")
                    }
                    .buttonStyle(LinkButtonStyle())
                    .sheet(isPresented: self.$showChromeProfileSheet) {
                        VStack {
                            Text("Please provide a profile directory name")
                            
                            Picker("Chrome Profile Directory", selection: self.$chromeProfileName) {
                                ForEach(profileManager.profiles) { profile in
                                    Text("\(profile.directory) (\(profile.label))")
                                        .tag(profile.directory)
                                }
                            }
                            .onChange(of: chromeProfileName) { newValue in
                                self.updateUserDefault(key: "ChromeProfile", value: newValue)
                            }
                            
                            Spacer().padding(.bottom, 20)
                            
                            HStack {
                                Button(action: {
                                    self.chromeProfileName = "Default"
                                    self.updateUserDefault(key: "ChromeProfile", value: self.chromeProfileName)
                                    self.showChromeProfileSheet.toggle()
                                }){
                                    Text("Reset To Default")
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    self.updateUserDefault(key: "ChromeProfile", value: self.chromeProfileName)
                                    self.showChromeProfileSheet.toggle()
                                }){
                                    Text("Close")
                                }
                            }
                        }
                        .padding(20)
                        .frame(width: 400)
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Text(self.chromeProfileName)
                        .onAppear{
                            self.chromeProfileName = UserDefaults.standard.string(forKey: "ChromeProfile") ?? "Default"
                    }
                    Spacer()
                }
            }
            .padding(.bottom, 15)
            
            VStack {
                HStack(alignment: .top) {
                    Text("Open Blank Tab URL")
                        .fontWeight(.bold)
                        .onAppear{
                            self.openBlankUrl = UserDefaults.standard.string(forKey: "OpenBlankUrl") ?? "Default"
                    }
                    
                    Button(action: {
                        self.openBlankUrlSheet.toggle()
                    }){
                        Text("Change")
                    }
                    .buttonStyle(LinkButtonStyle())
                    .sheet(isPresented: self.$openBlankUrlSheet) {
                        VStack {
                            Text("Please provide a profile directory name")
                            
                            TextField("Chrome Profile Directory", text: self.$openBlankUrl, onEditingChanged: { _ in
                                self.updateUserDefault(key: "OpenBlankUrl", value: self.openBlankUrl)
                            })
                            
                            Spacer().padding(.bottom, 20)
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    self.updateUserDefault(key: "OpenBlankUrl", value: self.openBlankUrl)
                                    self.openBlankUrlSheet.toggle()
                                }){
                                    Text("Close")
                                }
                            }
                        }
                        .padding(20)
                        .frame(width: 400)
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Text(self.openBlankUrl)
                    .onAppear {
                        self.openBlankUrl = UserDefaults.standard.string(forKey: "OpenBlankUrl") ?? "https://www.google.com"
                    }
                    Spacer()
                }
            }
            .padding(.bottom, 15)
            
            HStack {
                Toggle(isOn: $selectProfile) {
                    Text("Show profile selector before opening links")
                }
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            HStack {
                Toggle(isOn: launchAtStart) {
                    Text("Automatically start on launch")
                }
                .onAppear {
                    let foundHelper = NSWorkspace.shared.runningApplications.contains {
                        $0.bundleIdentifier == self.helperBundleName
                    }
                    
                    self.startOnStartUp = foundHelper
                }
                Spacer()
            }
            .padding(.bottom, 15)
            
            Spacer()
            
            HStack {
                Button(action: {
                    Helper.setAsDefaultBrowser()
                }) {
                    Text("Set As Default Browser")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                }
                .buttonStyle(CustomButtonStyle(bgColor: Color.blue, txtColor: .white))
            }
        }
        .padding()
    }
    
    func updateUserDefault(key k: String, value v: Any) -> Void {
        UserDefaults.standard.set(v, forKey: k)
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView(profileManager: ProfileManager())
    }
}
