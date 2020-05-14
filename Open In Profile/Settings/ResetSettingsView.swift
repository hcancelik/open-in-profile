//
//  ResetSettingsView.swift
//  Open In Profile
//
//  Created by H. Can Celik on 5/10/20.
//  Copyright © 2020 H. Can Celik. All rights reserved.
//

import SwiftUI

struct ResetSettingsView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        VStack {
            Text("This app keeps the last 10 visited urls locally but it does not save this list anywhere over the network. You can clear the history by clicking the button below.")
            
            Spacer()
            
            HStack {
                Button(action: {
                    self.showDeleteAlert.toggle()
                }) {
                    Text("Clear recent visited URLs")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                }
                .buttonStyle(CustomButtonStyle(bgColor: Color("Red-900"), txtColor: .white))
                .alert(isPresented: $showDeleteAlert) {
                    Alert(title: Text("Are you sure?"),
                          primaryButton: .destructive(Text("Reset")) {
                            self.resetCoreData()
                        },
                          secondaryButton: .cancel() {
                            self.showDeleteAlert.toggle()
                        })
                }
            }
        }
        .padding()
    }
    
    func resetCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VisitedUrl")
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            let result = try moc.execute(batchDeleteRequest) as! NSBatchDeleteResult
            
            let changes: [AnyHashable: Any] = [
                NSDeletedObjectsKey: result.result as! [NSManagedObjectID]
            ]
            
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [moc])
        } catch {
            print("Cannot delete storage")
        }
    }
}

struct ResetSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ResetSettingsView()
    }
}
