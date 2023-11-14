//
//  CardView.swift
//  survaid-ios
//
//  Created by James Liang on 11/14/23.
//

import SwiftUI

struct CardView: View{
    var body: some View{
        
        VStack(alignment: .leading) {
            Image("Sleep")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                .padding()
                .offset(x: -110)
                .offset(y: 20)
            Text("Sleep Apnea Survey")
                .fontWeight(.bold)
                .offset(x: 40)
                .offset(y: -80)
            Text("Completed: 100%")
                .offset(x: 40)
                .offset(y: -80)
            Text("Rating: 3/5")
                .offset(x: 40)
                .offset(y: -80)
        }
        .frame(maxWidth: .infinity, maxHeight: 160)
        .background(Color.survaidBlue)
    }
}

#Preview {
    CardView()
}
