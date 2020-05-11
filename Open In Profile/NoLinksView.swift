//
//  NoLinksView.swift
//  Open In Profile
//
//  Created by H. Can Celik on 5/9/20.
//  Copyright © 2020 H. Can Celik. All rights reserved.
//

import SwiftUI

struct NoLinksView: View {
    var body: some View {
        VStack {
            Image("Pages")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.gray)
            Text("You haven't opened any links yet.")
            .foregroundColor(Color.gray)
        }
    }
}

struct NoLinksView_Previews: PreviewProvider {
    static var previews: some View {
        NoLinksView()
    }
}
