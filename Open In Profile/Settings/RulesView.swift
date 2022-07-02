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
    @State private var selection: RuleViewModel.ID?
    @State private var showPopover = false
    
    var body: some View {
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
                .width(min: 275)

                TableColumn("Profile") { rule in
                    TextField("Profile", text: $ruleManager[rule.id].profile)
                        .onSubmit {
                            save(rule)
                        }
                }
                .width(ideal: 100)

                TableColumn("Order") { rule in
                    TextField("Order", value: $ruleManager[rule.id].order, formatter: NumberFormatter())
                        .onSubmit {
                            save(rule)
                        }
                }
                .width(ideal: 50)
            }
            .onDeleteCommand {
                if let id = selection {
                    selection = nil
                    
                    ruleManager.deleteRule(id)
                }
            }
        }
    }
    
    func save(_ rule: RuleViewModel) {
        ruleManager.updateRule(rule: rule)
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView(ruleManager: RuleManager())
    }
}
