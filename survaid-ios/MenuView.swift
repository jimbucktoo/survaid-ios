import SwiftUI

struct MenuView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SurveysView()
                .tabItem {
                    Image(systemName: "doc")
                    Text("Surveys")
                }
                .tag(0)
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.black, for: .tabBar)
            
            MessagesView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Messages")
                }
                .tag(1)
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.black, for: .tabBar)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(2)
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.black, for: .tabBar)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(3)
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.black, for: .tabBar)
        }
        .background(Color.black)
        .onAppear() {
            UITabBar.appearance().backgroundColor = .black
        }
        .tint(.survaidBlue)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MenuView()
}
