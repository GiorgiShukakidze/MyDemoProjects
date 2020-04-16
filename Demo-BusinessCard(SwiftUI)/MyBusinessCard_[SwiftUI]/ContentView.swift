//
//  ContentView.swift
//  MyBusinessCard_[SwiftUI]
//
//  Created by Giorgi Shukakidze on 2/6/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red:0.09, green:0.63, blue:0.52, opacity:1.0)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("Firmino")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 5)
                )
                Text("Roberto Firmino")
                    .font(Font.custom("Lobster-Regular", size: 40))
                    .bold()
                    .foregroundColor(.white)
                Text("Forward at Liverpool FC")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                Divider()
                InfoView(text: "+12 345 6789", imageName: "phone.fill")
                InfoView(text: "bfirmino@lfc.com", imageName: "envelope.fill")
            }
           
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
