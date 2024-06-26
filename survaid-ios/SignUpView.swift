import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift

struct SignUpView: View {
    @State private var ref = Database.database().reference()
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var signUpSuccess = false
    @State private var userUID: String = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userSession: UserSession
    
    func signUpUser() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let authResult = authResult {
                userUID = authResult.user.uid
                print("User UID: \(userUID)")
                ref.child("users").child(userUID).setValue(["email": email, "firstName": firstName, "lastName": lastName, "role": "Participant"])
                
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        print("Error signing in user: \(error.localizedDescription)")
                    } else {
                        userSession.signedIn = true
                        signUpSuccess = true
                        print("User signed in after registration")
                    }
                }
            } else if let error = error {
                print("Error creating user: \(error.localizedDescription)")
            }
        }
    }
    
    var body: some View {
        if (signUpSuccess) {
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
                              text: $firstName,
                              prompt: Text("First Name")
                        .foregroundColor(.black)
                    ).frame(width: 300, height: 50, alignment: .center).background(Color.white).cornerRadius(10).multilineTextAlignment(.center).foregroundColor(.black)
                    TextField("",
                              text: $lastName,
                              prompt: Text("Last Name")
                        .foregroundColor(.black)
                    ).frame(width: 300, height: 50, alignment: .center).background(Color.white).cornerRadius(10).multilineTextAlignment(.center).foregroundColor(.black)
                    TextField("",
                              text: $email,
                              prompt: Text("Email")
                        .foregroundColor(.black)
                    ).frame(width: 300, height: 50, alignment: .center).background(Color.white).cornerRadius(10).multilineTextAlignment(.center).foregroundColor(.black).autocapitalization(.none)
                    SecureField("",
                                text: $password,
                                prompt: Text("Password")
                        .foregroundColor(.black)
                    ).frame(width: 300, height: 50, alignment: .center).background(Color.white).cornerRadius(10).multilineTextAlignment(.center).foregroundColor(.black).autocapitalization(.none)
                    Button("Sign Up") {
                        signUpUser()
                    }
                    .foregroundColor(.white).frame(width: 300, height: 50).background(Color.blue).cornerRadius(10)
                }.padding(.bottom, 40)
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Sign In")
                }.foregroundColor(.white)
            })
        }
    }
}

#Preview {
    SignUpView()
}
