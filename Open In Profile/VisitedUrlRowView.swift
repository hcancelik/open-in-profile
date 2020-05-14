//
//  VisitedUrlRowView.swift
//  Open In Profile
//
//  Created by H. Can Celik on 5/9/20.
//  Copyright © 2020 H. Can Celik. All rights reserved.
//

import SwiftUI

struct VisitedUrlRowView: View {
    @ObservedObject var url: VisitedUrl
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(self.url.url)
                    .truncationMode(.tail)
                Text("Visited at \(self.formatDate(date: self.url.visitDate))")
                    .font(.system(size: 10))
                    .foregroundColor(Color.gray.opacity(0.8))
            }
            
            Spacer()
            
            Button(action: {
                Helper.openLink(url: self.url.url)
                
                self.closePopover()
            }) {
                Image(nsImage: NSImage(named: NSImage.followLinkFreestandingTemplateName)!)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: date)
    }
    
    func closePopover() {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        
        appDelegate?.closePopover(appDelegate)
    }
}

struct VisitedUrlRowView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let visitedUrl = VisitedUrl(context: context)
        visitedUrl.id = UUID()
        visitedUrl.url = "thisisaveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryverylongurl.com"
        visitedUrl.visitDate = Date()
        
        return VisitedUrlRowView(url: visitedUrl)
    }
}
