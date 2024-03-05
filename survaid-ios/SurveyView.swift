import SwiftUI
import FirebaseDatabase
import FirebaseDatabaseSwift

struct SurveyView: View {
    private var ref = Database.database().reference()
    let surveyId: String?
    @State private var surveyData: [String: Any]?
    @State private var blackImage: String = "https://firebasestorage.googleapis.com/v0/b/survaidapp-583db.appspot.com/o/black.jpg?alt=media&token=465f411a-ff69-4577-bd37-f1f539f39003"
    
    init(surveyId: String? = nil) {
        self.surveyId = surveyId
    }
    
    func loadSurvey() {
        ref.child("surveys/\(surveyId ?? "")" ).observeSingleEvent(of: .value, with: { snapshot in
            if let survey = snapshot.value as? [String: Any] {
                self.surveyData = survey
            }
        })
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if let survey = surveyData {
                    VStack {
                        ZStack {
                            Color.black
                            AsyncImage(url: URL(string: "\(survey["surveyImage"] as? String ?? "\(blackImage)")")) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                case .failure(let error):
                                    Text("Failed to load image: \(error.localizedDescription)")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 320)
                        NavigationLink(destination: QuestionView(surveyId: surveyId)) {
                            Text("Begin Survey")
                        }
                        .padding(20)
                        .background(Color.survaidBlue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
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
        .background(Color.black)
        .navigationTitle(surveyData?["title"] as? String ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarColor(.black)
        .onAppear{
            loadSurvey()
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
    SurveyView(surveyId: "-NsFRRs4f6D41Wca9wkn")
}
