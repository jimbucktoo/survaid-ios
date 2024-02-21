import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var signUpSuccess = false
    
    func signUpUser() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            print(authResult ?? "No Result")
            signUpSuccess = true
        }
    }
    
    var body: some View {
        if (signUpSuccess) {
            MenuView()
        } else {
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
                                  text: $firstName,
                                  prompt: Text("First Name")
                            .foregroundColor(.black)
                        ).frame(width: 300, height: 50, alignment: .center).background(Color.white).cornerRadius(10).multilineTextAlignment(.center)
                        TextField("",
                                  text: $lastName,
                                  prompt: Text("Last Name")
                            .foregroundColor(.black)
                        ).frame(width: 300, height: 50, alignment: .center).background(Color.white).cornerRadius(10).multilineTextAlignment(.center)
                        TextField("",
                                  text: $email,
                                  prompt: Text("Email")
                            .foregroundColor(.black)
                        ).frame(width: 300, height: 50, alignment: .center).background(Color.white).cornerRadius(10).multilineTextAlignment(.center)
                        SecureField("",
                                    text: $password,
                                    prompt: Text("Password")
                            .foregroundColor(.black)
                        ).frame(width: 300, height: 50, alignment: .center).background(Color.white).cornerRadius(10).multilineTextAlignment(.center)
                        Button("Sign Up") {
                            signUpUser()
                        }
                        .foregroundColor(.white).frame(width: 300, height: 50).background(Color.blue).cornerRadius(10)
                    }
                }
            }
        }
    }
}

#Preview {
    SignUpView()
}
