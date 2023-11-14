//
//  SettingsView.swift
//  survaid-ios
//
//  Created by James Liang on 10/16/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.survaidBlue)
                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.survaidBlue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.horizontal, 20)
        }.background(Color.black)
    }
}

#Preview {
    SettingsView()
}
