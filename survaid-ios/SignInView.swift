import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var userSession: UserSession
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                print(error ?? "Sign In Error")
                return
            }
            print(authResult ?? "AuthResult")
            userSession.signedIn = true
            email = ""
            password = ""
        }
    }
    
    var body: some View {
        if (userSession.signedIn) {
            MenuView()
        } else {
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
                              text: $email,
                              prompt: Text("Email")
                        .foregroundColor(.black)
                    ).frame(width: 300, height: 50, alignment: .center).background(Color.white).cornerRadius(10).multilineTextAlignment(.center).foregroundColor(.black)
                    SecureField("",
                                text: $password,
                                prompt: Text("Password")
                        .foregroundColor(.black)
                    ).frame(width: 300, height: 50, alignment: .center).background(Color.white).cornerRadius(10).multilineTextAlignment(.center).foregroundColor(.black)
                    Button("Sign In") {
                        signIn()
                    }
                    .foregroundColor(.white).frame(width: 300, height: 50).background(Color.blue).cornerRadius(10)
                    NavigationLink(destination: SignUpView()) {
                        Text("Don't have an account? Sign up now").padding(.top, 20).foregroundColor(.survaidBlue)
                    }
                }
            }
        }
    }
}

#Preview {
    SignInView().environmentObject(UserSession())
}
