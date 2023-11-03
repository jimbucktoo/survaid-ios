//
//  MenuView.swift
//  survaid-ios
//
//  Created by James Liang on 11/2/23.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        TabView {
            SurveysView()
                .tabItem {
                    Image(systemName: "doc")
                    Text("Surveys")
                }.tint(.blue)
            MessagesView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Messages")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MenuView()
}
