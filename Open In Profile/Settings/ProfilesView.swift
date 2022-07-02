//
//  ProfilesView.swift
//  Open In Profile
//
//  Created by H. Can Celik on 7/2/22.
//  Copyright © 2022 H. Can Celik. All rights reserved.
//

import SwiftUI

struct ProfilesView: View {
    @StateObject var profileManager: ProfileManager
    @State private var selection: ProfileViewModel.ID?
    @State private var showAlert: Bool = false
    @State private var showPopover = false
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 10)
            
            HStack {
                Button(action: {
                    self.showPopover.toggle()
                }) {
                    Label("How To Find Directories?", systemImage: "info.circle")
                }
                .buttonStyle(PlainButtonStyle())
                .popover(isPresented: self.$showPopover) {
                    VStack {
                        Text("Where Can I Find My Chrome Profile Directory Name?")
                            .fontWeight(.black)
                            .padding(.bottom, 20)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("To determine the profile directory for a running Chrome instance:")
                                .padding(.bottom, 10)
                            
                            Text("1. Navigate to chrome://version")
                            Text("2. Look for the Profile Path field. This gives the path to full profile directory.")
                            Text("3. The profile directory name is the last directory of the profile directory.")
                                .padding(.bottom, 10)
                            
                            HStack(spacing: 0) {
                                Text("For example profile directory name for the below path is ")
                                    .padding(0)
                                Text("Default")
                                    .fontWeight(.black)
                                Spacer()
                            }
                            .padding(.bottom, 20)
                            
                            HStack(spacing: 0) {
                                Text("/Users/apple/Library/Application Support/Google/Chrome/")
                                    .padding(0)
                                Text("Default")
                                    .fontWeight(.black)
                            }
                        }
                    }
                    .padding(20)
                }
                
                Spacer()
                
                Button {
                    profileManager.addProfile()
                } label: {
                    Label("Add New Profile", systemImage: "plus")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                }
                .buttonStyle(CustomButtonStyle(bgColor: Color("Green-500"), txtColor: .white))
                
                Button {
                    delete()
                } label: {
                    Label("Delete Profile", systemImage: "trash")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                }
                .buttonStyle(CustomButtonStyle(bgColor: Color("Red-900"), txtColor: .white))
                .opacity(selection == nil ? 0.4 : 1)
                .disabled(selection == nil)
            }
            .padding(.horizontal, 5)
            
            
            Table(profileManager.profiles, selection: $selection) {
                TableColumn("Label") { profile in
                    TextField("Domain/URL", text: $profileManager[profile.id].label)
                        .onSubmit {
                            save(profile)
                        }
                }
                .width(min: 200)

                TableColumn("Directory") { profile in
                    TextField("Directory", text: $profileManager[profile.id].directory)
                        .disabled(profile.directory == "Default")
                        .onSubmit {
                            save(profile)
                        }
                }
                .width(ideal: 200)

                TableColumn("Order") { profile in
                    TextField("Order", value: $profileManager[profile.id].order, formatter: NumberFormatter())
                        .onSubmit {
                            save(profile)
                        }
                }
                .width(ideal: 35)
            }
            .onDeleteCommand {
               delete()
            }
            .alert("You cannot delete default profile", isPresented: $showAlert) {
                Button {
                    showAlert.toggle()
                } label: {
                    Text("Okay")
                }
            }
        }
        .onAppear {
            profileManager.fetchProfiles()
        }
    }
    
    func delete() {
        if let id = selection {
            if let profile = profileManager.profiles.first(where: { $0.id == id }) {
                if profile.directory == "Default" {
                    showAlert.toggle()
                    
                    return
                }
            }
            
            selection = nil

            profileManager.deleteProfile(id: id)
        }
    }
    
    func save(_ profile: ProfileViewModel) {
        profileManager.updateProfile(profile: profile)
    }
}

struct ProfilesView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilesView(profileManager: ProfileManager())
    }
}
