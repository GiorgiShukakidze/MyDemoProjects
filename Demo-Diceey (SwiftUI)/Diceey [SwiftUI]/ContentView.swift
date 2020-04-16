//
//  ContentView.swift
//  Diceey [SwiftUI]
//
//  Created by Giorgi Shukakidze on 2/7/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var leftDiceNumber = 1
    @State var rightDiceNumber = 1
    @State var totalScore = 0
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text("Score: \(totalScore)")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    Spacer()
                    Button(action: {
                        self.totalScore = 0
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                Image("diceeLogo")
                Spacer()
                HStack {
                    DiceView(n: leftDiceNumber)
                    DiceView(n: rightDiceNumber)
                }
                .padding(.horizontal)
                Spacer()
                Button(action:  {
                    self.leftDiceNumber = Int.random(in: 1...6)
                    self.rightDiceNumber = Int.random(in: 1...6)
                    
                    self.totalScore += self.leftDiceNumber + self.rightDiceNumber
                }) {
                    Text("Roll")
                        .font(.system(size: 45))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }
                .background(Color(#colorLiteral(red: 0.6622132659, green: 0, blue: 0.08407194167, alpha: 1)))
            }
        }
    }
}

struct DiceView: View {
    let n: Int
    var body: some View {
        Image("dice\(n)")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


