import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @EnvironmentObject var userSession: UserSession
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            userSession.signedIn = false
            print("Signed Out")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    var body: some View {
        if userSession.signedIn == false {
            SignInView()
        } else {
            NavigationStack {
                VStack {
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
                    VStack {
                        ScrollView {
                            Divider().background(Color.white)
                            NavigationLink(destination: ChangeProfilePictureView()) {
                                HStack {
                                    Text("Change Profile Picture")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                }.padding(.top, 20).padding(.bottom, 20).padding(.leading, 20)
                            }
                            Divider().background(Color.white)
                            NavigationLink(destination: EditParticipantInformationView()) {
                                HStack {
                                    Text("Participant Information")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                }.padding(.top, 20).padding(.bottom, 20).padding(.leading, 20)
                            }
                            Divider().background(Color.white)
                            Button(action: {
                                signOut()
                            }) {
                                Text("Sign Out")
                                    .foregroundColor(.red)
                                    .font(.system(size: 20))
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                        }
                    }
                }.background(Color.black)
            }
        }
    }
}

#Preview {
    SettingsView().environmentObject(UserSession())
}
