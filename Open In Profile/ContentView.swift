//
//  ContentView.swift
//  Open In Profile
//
//  Created by H. Can Celik on 3/29/20.
//  Copyright © 2020 H. Can Celik. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: VisitedUrl.entity(),
                  sortDescriptors: [NSSortDescriptor.init(key: "visitDate", ascending: false)]) var recentUrls: FetchedResults<VisitedUrl>
    
    @State private var wantToQuitAlert: Bool = false
    @State private var showAvailableUpdateAlert: Bool = false
    
    let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
        styleMask: [.titled, .closable],
        backing: .buffered, defer: true)
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Recently Opened URLs")
                    .bold()
                    .font(.headline)
                Spacer()
            }
            .padding()
            .background(Color.black.opacity(0.9))
            .foregroundColor(.white)
            
            VStack {
                if(recentUrls.isEmpty) {
                    NoLinksView()
                }
                else {
                    VStack() {
                        ForEach(self.recentUrls, id: \.id) { url in
                            VisitedUrlRowView(url: url)
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
            .alert(isPresented: self.$wantToQuitAlert) {
                Alert(title: Text("Are you sure you want to quit?"),
                      message: Text("If Open In Profile is your default browser and you click a link, it will reopen again."),
                      primaryButton: .destructive(Text("Quit")) {
                        self.terminate()
                    },
                      secondaryButton: .cancel() {
                        self.wantToQuitAlert.toggle()
                    })
            }
            
            Spacer()
            
            VStack() {
                HStack {
                    Button(action: {
                        self.openSettingMenu()
                    }) {
                        Image(nsImage: NSImage(named: NSImage.smartBadgeTemplateName)!)
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        let url = UserDefaults.standard.string(forKey: "OpenBlankUrl") ?? "https://www.google.com"
                        
                        Helper.openLink(url: url)
                        
                        self.closePopover()
                    }) {
                        Text("Open Blank Tab")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(CustomButtonStyle(bgColor: Color.black.opacity(0.7), txtColor: .white))
                    
                    Spacer()
                    
                    Button(action: {
                        self.wantToQuitAlert.toggle()
                    }) {
                        Image(nsImage: NSImage(named: NSImage.stopProgressFreestandingTemplateName)!)
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.gray.opacity(0.1))
            }
            .alert(isPresented: self.$showAvailableUpdateAlert) {
                Helper.markUpdateNotificationAsRead()
                
                return Alert(title: Text("New version of Open In Profile is available."),
                             message: Text("You can download the new version from the website."),
                             primaryButton: .destructive(Text("Go To Website")) {
                                Helper.goToWebPage()
                    },
                             secondaryButton: .cancel(Text("Close")) {
                                self.showAvailableUpdateAlert.toggle()
                    })
            }
        }
        .background(Color.white)
        .onAppear {
            let settingsView = SettingsView().environment(\.managedObjectContext, self.moc)
            
            self.window.center()
            self.window.setFrameAutosaveName("Settings")
            self.window.title = "Settings"
            self.window.contentView = NSHostingView(rootView: settingsView)
            self.window.isReleasedWhenClosed = false
            self.window.orderOut(self)
            
            self.showAvailableUpdateAlert = Helper.checkIfUserShouldAlertedForAvailableUpdate()
        }
    }
    
    
    func closePopover() {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        
        appDelegate?.closePopover(appDelegate)
    }
    
    func terminate() {
        NSApplication.shared.terminate(self)
    }
    
    func openSettingMenu() {
        self.closePopover()
        self.window.orderFront(self)
        self.window.makeKeyAndOrderFront(nil)
    }
}

struct CustomButtonStyle: ButtonStyle {
    var bgColor: Color
    var txtColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(txtColor)
            .background(bgColor)
            .cornerRadius(5)
            .offset(y: configuration.isPressed ? 2.0 : 0.0)
            .shadow(radius: 3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return ContentView().environment(\.managedObjectContext, context)
    }
}
