import SwiftUI

struct ContentView: View {
    
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.survaidBlue.ignoresSafeArea()
                Circle().scale(1.7).foregroundColor(.survaidOrange)
                Circle().scale(1.35).foregroundColor(.black)
                VStack {
                    HStack(spacing: 0) {
                        Text("Surv").font(.largeTitle).bold().foregroundColor(.survaidBlue)
                        Text("aid").font(.largeTitle).bold().foregroundColor(.survaidOrange)
                    }.padding()
                    TextField("",
                              text: $username,
                              prompt: Text("Username")
                        .foregroundColor(.black)
                    ).frame(width: 300, height: 50, alignment: .center).background(Color.white).cornerRadius(10).multilineTextAlignment(.center)
                    SecureField("",
                                text: $password,
                                prompt: Text("Password")
                        .foregroundColor(.black)
                    ).frame(width: 300, height: 50, alignment: .center).background(Color.white).cornerRadius(10).multilineTextAlignment(.center)
                    NavigationLink(destination: MenuView(), label: {
                        Button("Login") {
                            
                        }
                        .foregroundColor(.white).frame(width: 300, height: 50).background(Color.blue).cornerRadius(10)
                    })
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
