import SwiftUI

struct MenuView: View {
    var body: some View {
        TabView {
            SurveysView()
                .tabItem {
                    Image(systemName: "doc")
                    Text("Surveys")
                }
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(
                    Color.black,
                    for: .tabBar)
            MessagesView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Messages")
                }
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(
                    Color.black,
                    for: .tabBar)
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(
                    Color.black,
                    for: .tabBar)
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(
                    Color.black,
                    for: .tabBar)
        }
        .background(Color.black)
        .onAppear() {
            UITabBar.appearance().backgroundColor = .black
        }.tint(.survaidBlue)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MenuView()
}
