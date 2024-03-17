import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift

struct SurveyView: View {
    private var ref = Database.database().reference()
    let surveyId: String?
    let user = Auth.auth().currentUser
    @Environment(\.dismiss) private var dismiss
    @State private var surveyData: [String: Any]?
    @State private var status: String = "Not Started"
    @State private var blackImage: String = "https://firebasestorage.googleapis.com/v0/b/survaidapp-583db.appspot.com/o/black.jpg?alt=media&token=465f411a-ff69-4577-bd37-f1f539f39003"
    
    init(surveyId: String? = nil) {
        self.surveyId = surveyId
    }
    
    func loadStatus() {
        ref.child("surveys/\(surveyId ?? "")/status/\(user?.uid ?? "")").observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                if let statusData = snapshot.value as? String {
                    self.status = statusData
                }
            } else {
                ref.child("surveys/\(surveyId ?? "")/status/\(user?.uid ?? "")").setValue("Not Started") { error, _ in
                    if let error = error {
                        print("Error updating status: \(error.localizedDescription)")
                    } else {
                        self.status = "Not Started"
                        print("Status updated successfully")
                    }
                }
            }
        })
    }
    
    func loadSurvey() {
        ref.child("surveys/\(surveyId ?? "")" ).observeSingleEvent(of: .value, with: { snapshot in
            if let survey = snapshot.value as? [String: Any] {
                self.surveyData = survey
            }
        })
    }
    
    func participate() {
        if status == "Not Started" {
            var usersArray = [String]()
            ref.child("surveys/\(surveyId ?? "")/participants").observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    if let participants = snapshot.value as? [String] {
                        usersArray.append(contentsOf: participants)
                    }
                    if let currentUserUID = user?.uid {
                        usersArray.append(currentUserUID)
                    }
                    ref.child("surveys/\(surveyId ?? "")/participants").setValue(usersArray) { error, _ in
                        if let error = error {
                            print("Error updating participants: \(error.localizedDescription)")
                        } else {
                            print("Participants updated successfully")
                        }
                    }
                } else {
                    usersArray.append(user?.uid ?? "")
                    print(usersArray)
                    ref.child("surveys/\(surveyId ?? "")/participants").setValue(usersArray) { error, _ in
                        if let error = error {
                            print("Error updating participants: \(error.localizedDescription)")
                        } else {
                            print("Participants updated successfully")
                        }
                    }
                }
            })
        }
        ref.child("surveys/\(surveyId ?? "")/status/\(user?.uid ?? "")").setValue("Started") { error, _ in
            if let error = error {
                print("Error updating status: \(error.localizedDescription)")
            } else {
                print("Status updated successfully")
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if let survey = surveyData {
                    VStack(spacing: 0) {
                        ZStack {
                            AsyncImage(url: URL(string: "\(survey["surveyImage"] as? String ?? "\(blackImage)")")) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity, maxHeight: 200)
                                case .failure(let error):
                                    Text("Failed to load image: \(error.localizedDescription)")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        .clipped()
                        VStack {
                            Text("Status: \(status)")
                                .foregroundColor(.white)
                        }
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(
                            status == "Not Started" ? Color.survaidBlue :
                                status == "Started" ? Color.survaidOrange :
                                status == "Completed" ? Color.black :
                                Color.black
                        )
                        .edgesIgnoringSafeArea(.all)
                        if status != "Completed" {
                            NavigationLink(destination: QuestionView(surveyId: surveyId).onAppear {
                                self.participate()
                            }) {
                                Text(status == "Started" ? "Continue Survey" : "Begin Survey")
                            }
                            .padding(20)
                            .background(status == "Started" ? Color.survaidOrange : Color.survaidBlue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                        }
                        HStack {
                            Image(systemName: "person.fill").foregroundColor(.black).padding(.leading, 10).padding(.top, 10).padding(.bottom, 10)
                            Text(survey["createdByEmail"] as? String ?? "").foregroundColor(.black).padding(.top, 10)
                            Spacer()
                            Text("Price: $\(survey["price"] as? String ?? "")").foregroundColor(.black).padding(.trailing, 10).padding(.top, 10)
                        }
                        HStack {
                            Image(systemName: "text.bubble.fill").foregroundColor(.black).padding(.leading, 10).padding(.top, 10)
                            Text("Comments").foregroundColor(.black).padding(.top, 10)
                            Spacer()
                            Image(systemName: "person.2.fill").foregroundColor(.black).padding(.leading, 10).padding(.top, 10)
                            Text("Participants").foregroundColor(.black).padding(.trailing, 10).padding(.top, 10)
                        }
                        VStack {
                            HStack {
                                Text(survey["title"] as? String ?? "")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.leading, 10)
                                    .padding(.top, 10)
                                Spacer()
                            }
                            HStack {
                                Text(survey["description"] as? String ?? "")
                                    .foregroundColor(.black)
                                    .padding(.leading, 10)
                                    .padding(.top, 2)
                                Spacer()
                            }.frame(maxHeight: .infinity, alignment: .leading)
                            Spacer()
                        }
                    }
                    .frame(maxHeight: .infinity).overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2)).background(Color.white)
                } else {
                    ProgressView()
                }
            }.background(Color.black).cornerRadius(10)
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Surveys")
            }
        }
        )
        .background(Color.black)
        .onAppear{
            loadSurvey()
            loadStatus()
        }
    }
}

extension View {
    func navigationBarColor(_ color: UIColor) -> some View {
        modifier(NavigationBarColorModifier(color: color))
    }
}

struct NavigationBarColorModifier: ViewModifier {
    let color: UIColor
    
    init(color: UIColor) {
        self.color = color
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = color
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = .white
    }
    
    func body(content: Content) -> some View {
        content
    }
}

#Preview {
    SurveyView(surveyId: "-NstKg4GUvuAyxN2WLhk")
}
