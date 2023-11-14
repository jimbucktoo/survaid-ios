//
//  ProfileView.swift
//  survaid-ios
//
//  Created by James Liang on 10/16/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                Text("Jimmy Liang")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.horizontal, 20)
            Rectangle().fill(Color.blue).frame(height: 100)
            Rectangle().fill(Color.blue).frame(height: 100)
        }.background(Color.black)
    }
}

#Preview {
    ProfileView()
}
