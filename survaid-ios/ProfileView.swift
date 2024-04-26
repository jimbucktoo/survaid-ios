import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseStorage

struct ProfileView: View {
    let user = Auth.auth().currentUser
    private var dbRef = Database.database().reference()
    private var storageRef = Storage.storage().reference()
    
    @State private var userProfile: [String: Any]?
    @State private var index = 0
    
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
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.survaidBlue)
                    Text("\(userProfile?["firstName"] ?? "") \(userProfile?["lastName"] ?? "")")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.survaidBlue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
                .padding(.horizontal, 20)
                VStack(spacing: 0) {
                    VStack {
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
                                        .frame(width: 200, height: 200)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                                case .failure(let error):
                                    Text("Failed to load image: \(error.localizedDescription)")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        Text("\(userProfile?["firstName"] ?? "") \(userProfile?["lastName"] ?? "")")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                        Text("\(userProfile?["email"] ?? "")")
                            .foregroundColor(.white)
                            .padding(.top, 2)
                    }.padding(.top, 20).padding(.bottom, 20)
                    VStack {
                        NavigationLink(destination: ParticipantInformationView()) {
                            HStack {
                                Image(systemName: "person.fill")
                                    .renderingMode(.original)
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 10)
                                Spacer()
                                Text("Participant Information")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .frame(width: 340, height: 60)
                            .background(Color.survaidBlue)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        NavigationLink(destination: ActiveSurveysView()) {
                            HStack {
                                Image(systemName: "doc")
                                    .renderingMode(.original)
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 10)
                                Spacer()
                                Text("Active Surveys")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .frame(width: 340, height: 60)
                            .background(Color.survaidBlue)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        NavigationLink(destination: CompletedSurveysView()) {
                            HStack {
                                Image(systemName: "doc.fill")
                                    .renderingMode(.original)
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 10)
                                Spacer()
                                Text("Completed Surveys")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .frame(width: 340, height: 60)
                            .background(Color.survaidBlue)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                    }.padding(.top, 20)
                    Spacer()
                }
            }.background(Color.black)
        }
        .onAppear{
            loadProfile()
        }
    }
}

#Preview {
    ProfileView()
}
