//
//  InfoView.swift
//  MyBusinessCard_[SwiftUI]
//
//  Created by Giorgi Shukakidze on 2/6/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import SwiftUI

struct InfoView: View {
    let text: String
    let imageName: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 50)
            .frame(height: 50, alignment: .center)
            .foregroundColor(.white)
            .overlay(
                HStack{
                    Image(systemName: imageName)
                        .foregroundColor(.green)
                    Text(text)
                        .bold()
                }
        )
            .padding(.all)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(text: "Hello", imageName: "phone.fill")
            .previewLayout(.sizeThatFits)
    }
}
