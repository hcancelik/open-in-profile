//
//  RulesView.swift
//  Open In Profile
//
//  Created by H. Can Celik on 6/28/22.
//  Copyright © 2022 H. Can Celik. All rights reserved.
//

import SwiftUI

struct RulesView: View {
    @StateObject var ruleManager: RuleManager
    @ObservedObject var profileManager: ProfileManager
    @State private var selection: RuleViewModel.ID?
    @State private var showPopover = false
    @AppStorage("selectProfile") private var selectProfile = false
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 10)
        
            if selectProfile {
                Text("This option is not available when you select show profile selector before opening links under general settings.")
                    .multilineTextAlignment(.center)
                
            } else {
                VStack {
                    HStack {
                        Button(action: {
                            self.showPopover.toggle()
                        }) {
                            Label("How It Works?", systemImage: "info.circle")
                        }
                        .buttonStyle(PlainButtonStyle())
                        .popover(isPresented: self.$showPopover) {
                            VStack {
                                Text("How It Works?")
                                    .fontWeight(.black)
                                    .padding(.bottom, 20)
                                
                                Text("Based on the rule order, the app will go through each rule to see if the link contains the given string.")
                                    .padding(.bottom, 20)
                                
                                Text("If a match is found it will be opened in the selected profile for that rule.")
                                    .padding(.bottom, 20)
                                
                                Text("If no match is found then it will be opened in the default profile.")
                                    .padding(.bottom, 20)
                                
                                Divider()
                                    .padding(.bottom, 20)
                                
                                Text("If you ever need to open a link in Safari instead of Chrome set **Safari** as the profile.")
                            }
                            .padding(20)
                        }
                        
                        Spacer()
                        
                        Button {
                            ruleManager.addNewRule()
                        } label: {
                            Label("Add New Rule", systemImage: "plus")
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                        }
                        .buttonStyle(CustomButtonStyle(bgColor: Color("Green-500"), txtColor: .white))
                        
                        
                        Button {
                            if let id = selection {
                                selection = nil
                                
                                ruleManager.deleteRule(id)
                            }
                        } label: {
                            Label("Delete Rule", systemImage: "trash")
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                        }
                        .buttonStyle(CustomButtonStyle(bgColor: Color("Red-900"), txtColor: .white))
                        .opacity(selection == nil ? 0.4 : 1)
                        .disabled(selection == nil)
                    }
                    .padding(.horizontal, 5)
                    
                    
                    Table(ruleManager.rules, selection: $selection) {
                        TableColumn("Domain/URL/String") { rule in
                            TextField("Domain/URL", text: $ruleManager[rule.id].criteria)
                                .onSubmit {
                                    save(rule)
                                }
                        }
                        .width(min: 270)
                        
                        TableColumn("Profile") { rule in
                            Picker("", selection: $ruleManager[rule.id].profile) {
                                ForEach(profileManager.profiles) { profile in
                                    Text(profile.label)
                                        .tag(profile.directory)
                                }
                            }
                            .onChange(of: ruleManager[rule.id].profile) { _ in
                                save(rule)
                            }
                        }
                        .width(ideal: 120)
                        
                        TableColumn("Order") { rule in
                            TextField("Order", value: $ruleManager[rule.id].order, formatter: NumberFormatter())
                                .onSubmit {
                                    save(rule)
                                }
                        }
                        .width(ideal: 35)
                    }
                    .onDeleteCommand {
                        if let id = selection {
                            selection = nil
                            
                            ruleManager.deleteRule(id)
                        }
                    }
                }
                .onAppear {
                    ruleManager.fetchRules()
                }
            }
            
            Spacer()
        }
    }
    
    func save(_ rule: RuleViewModel) {
        ruleManager.updateRule(rule: rule)
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView(ruleManager: RuleManager(), profileManager: ProfileManager())
    }
}
