//
//  DetailView.swift
//  Hacker News
//
//  Created by Giorgi Shukakidze on 2/9/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    let url: String?
    
    var body: some View {
        WebView(urlString: url)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: "https://www.google.com")
    }
}
