import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseStorage

struct ParticipantInformationView: View {
    @State private var participantInfo = ""
    @State private var userProfile: [String: Any]?
    let user = Auth.auth().currentUser
    private var dbRef = Database.database().reference()
    private var storageRef = Storage.storage().reference()
    
    func loadProfile() {
        dbRef.child("users").observeSingleEvent(of: .value, with: { snapshot in
            if let users = snapshot.value as? [String: Any] {
                for (userId, userData) in users {
                    if userId == user?.uid {
                        self.userProfile = userData as? [String: Any]
                        break
                    }
                }
            }
        })
    }
    
    func loadParticipantInformation() {
        dbRef.child("users/\(user?.uid ?? "")/participantInformation").observeSingleEvent(of: .value, with: { snapshot in
            if let participantInformation = snapshot.value as? String {
                participantInfo = participantInformation
                print(participantInformation)
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.survaidBlue)
                Text("Participant Information")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.survaidBlue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.horizontal, 20)
            VStack {
                Spacer()
                if let profileData = userProfile {
                    AsyncImage(url: URL(string: "\(profileData["profilePicture"] ?? "")")) { phase in
                        switch phase {
                        case .empty:
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 100))
                                .foregroundColor(.survaidBlue)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        case .failure(let error):
                            Text("Failed to load image: \(error.localizedDescription)")
                        @unknown default:
                            EmptyView()
                        }
                        Text("\(userProfile?["firstName"] ?? "") \(userProfile?["lastName"] ?? "")")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                        Text("\(userProfile?["email"] ?? "")")
                            .foregroundColor(.white)
                            .padding(.top, 2)
                    }.padding(.top, 40)
                }
                if (participantInfo != "") {
                    Text("About \(userProfile?["firstName"] ?? ""): \(participantInfo)")
                        .padding(.top, 10)
                        .font(.body)
                } else {
                    Text("No Participant Information Available")
                        .padding(.top, 10)
                        .font(.body)
                }
            }
        }
        .background(Color.black)
        .onAppear{
            loadProfile()
            loadParticipantInformation()
        }
    }
}

#Preview {
    ParticipantInformationView()
}
