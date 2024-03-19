import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseStorage

struct ActiveSurveysView: View {
    @State var activeSurveys: [ActiveSurvey] = []
    let user = Auth.auth().currentUser
    private var dbRef = Database.database().reference()
    private var storageRef = Storage.storage().reference()
    
    func loadSurveys(userId: String) {
        dbRef.child("surveys").observeSingleEvent(of: .value, with: { snapshot in
            if let surveys = snapshot.value as? [String: Any] {
                for (surveyId, surveyData) in surveys {
                    if let surveyInfo = surveyData as? [String: Any],
                       let participants = surveyInfo["participants"] as? [String],
                       participants.contains(userId),
                       let statusData = surveyInfo["status"] as? [String: String],
                       statusData[userId] == "Started" {
                        let title = surveyInfo["title"] as? String ?? ""
                        let surveyImage = surveyInfo["surveyImage"] as? String ?? ""
                        let survey = ActiveSurvey(id: surveyId, title: title, surveyImage: surveyImage)
                        self.activeSurveys.append(survey)
                    }
                }
                print(activeSurveys)
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "doc")
                    .font(.system(size: 40))
                    .foregroundColor(.survaidBlue)
                Text("Active Surveys")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.survaidBlue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.horizontal, 20)
            LazyVStack {
                ForEach(activeSurveys, id: \.id) { survey in
                    Divider().background(Color.white)
                    NavigationLink(destination: SurveyView(surveyId: survey.id)) {
                        HStack {
                            AsyncImage(url: URL(string: "\(survey.surveyImage)")) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                        .clipShape(Circle())
                                case .failure(let error):
                                    Text("Failed to load image: \(error.localizedDescription)")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            VStack (alignment: .leading) {
                                HStack {
                                    Text("\(survey.title)")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .padding(.top, 4)
                                        .padding(.leading, 4)
                                    Spacer()
                                }
                            }
                            .padding(.bottom, 10)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            Spacer()
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    }
                }
            }.padding(.leading, 10)
        }
        .background(Color.black)
        .onAppear{
            loadSurveys(userId: "\(user?.uid ?? "")")
        }
    }
}

struct ActiveSurvey {
    let id: String
    let title: String
    let surveyImage: String
}

#Preview {
    ActiveSurveysView()
}
