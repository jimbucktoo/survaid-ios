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
            ScrollView {
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
                    ZStack {
                        Rectangle()
                            .fill(Color.black)
                            .frame(height: 180)
                        VStack {
                            Image("jamesliang")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                            Spacer()
                            Text("\(userProfile?["firstName"] ?? "") \(userProfile?["lastName"] ?? "")")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            Text("\(userProfile?["email"] ?? "")")
                                .foregroundColor(.white)
                        }.padding(.bottom, 20)
                    }
                    ZStack {
                        Rectangle().fill(Color.survaidBlue).frame(height: 140)
                        VStack{
                            TabView(selection: $index) {
                                ForEach((0..<4), id: \.self) { index in
                                    CardView()
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        }
                        .frame(height: 140)
                    }
                    ZStack {
                        Rectangle().fill(Color.black).frame(height: 320)
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
                            NavigationLink(destination: ReviewsView()) {
                                HStack {
                                    Image(systemName: "person.text.rectangle.fill")
                                        .renderingMode(.original)
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 30)
                                        .padding(.leading, 10)
                                    Spacer()
                                    Text("Reviews")
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
                        }
                    }
                }
            }
            .background(Color.black)
            .onAppear{
                loadProfile()
            }
        }
    }
}

#Preview {
    ProfileView()
}
