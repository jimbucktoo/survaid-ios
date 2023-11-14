//
//  MessagesView.swift
//  survaid-ios
//
//  Created by James Liang on 10/16/23.
//

import SwiftUI

struct MessagesView: View {
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "message.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                Text("Messages")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.horizontal, 20)
        }.background(Color.black)
    }
}

#Preview {
    MessagesView()
}
