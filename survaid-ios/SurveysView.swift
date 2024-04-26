import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseStorage

struct SurveysView: View {
    private var ref = Database.database().reference()
    private var storageRef = Storage.storage().reference()
    
    @State var surveysData: [Survey] = []
    @State var isLoading: Bool = true
    
    func calculateTimeDifference(for timestamp: TimeInterval) -> String {
        let currentTime = Date().timeIntervalSince1970 * 1000
        let timeDifferenceMinutes = Int(currentTime - timestamp) / 60000
        
        if timeDifferenceMinutes < 60 {
            return "\(timeDifferenceMinutes)m"
        } else if timeDifferenceMinutes < 1440 {
            let hours = timeDifferenceMinutes / 60
            let remainingMinutes = timeDifferenceMinutes % 60
            if remainingMinutes == 0 {
                return "\(hours)hr"
            } else {
                return "\(hours)hr \(remainingMinutes)m"
            }
        } else {
            let days = timeDifferenceMinutes / 1440
            return "\(days)d"
        }
    }
    
    func loadSurveys() {
        surveysData = []
        ref.child("surveys").observeSingleEvent(of: .value, with: { snapshot in
            if let surveys = snapshot.value as? [String: Any] {
                for (key, value) in surveys {
                    if let surveyData = value as? [String: Any] {
                        let createdBy = surveyData["createdBy"] as? String ?? ""
                        let description = surveyData["description"] as? String ?? ""
                        let price = surveyData["price"] as? String ?? ""
                        let title = surveyData["title"] as? String ?? ""
                        let email = surveyData["createdByEmail"] as? String ?? ""
                        let timestamp = surveyData["createdAt"] as? TimeInterval ?? 0
                        let image = surveyData["surveyImage"] as? String ?? ""
                        let survey = Survey(id: key, createdBy: createdBy, description: description, price: price, title: title, email: email, createdAt: timestamp, surveyImage: image)
                        self.surveysData.append(survey)
                        self.surveysData.sort { $0.createdAt > $1.createdAt }
                    }
                }
                self.isLoading = false
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView().onAppear{
                    loadSurveys()
                }
            } else {
                VStack {
                    HStack {
                        Image(systemName: "doc.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.survaidBlue)
                        Text("Surveys")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.survaidBlue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .background(Color.black)
                    ScrollView {
                        LazyVStack {
                            ForEach(surveysData, id: \.id) { survey in
                                let timeDifference = calculateTimeDifference(for: survey.createdAt)
                                HStack {
                                    NavigationLink(destination: SurveyView(surveyId: survey.id), label: {
                                        VStack {
                                            HStack {
                                                Image(systemName: "doc.fill").foregroundColor(.survaidBlue).padding(.leading, 10).padding(.bottom, 10)
                                                Text("\(survey.title)").foregroundColor(.survaidBlue)
                                                    .fontWeight(.bold)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                    .padding(.bottom, 10)
                                                Spacer()
                                                Text("\(timeDifference)").foregroundColor(.survaidOrange).fontWeight(.bold).padding(.trailing, 10).padding(.bottom, 10)
                                            }.padding(.top, 20)
                                            ZStack {
                                                AsyncImage(url: URL(string: "\(survey.surveyImage)")) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(maxWidth: .infinity, maxHeight: 180)
                                                    case .failure(let error):
                                                        Text("Failed to load image: \(error.localizedDescription)")
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                            }.clipped()
                                            HStack {
                                                Image(systemName: "person.fill").foregroundColor(.black).padding(.leading, 10).padding(.bottom, 10)
                                                Text("\(survey.email)").foregroundColor(.black)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                    .padding(.bottom, 10)
                                                Spacer()
                                                Text("Price: $\(survey.price)").foregroundColor(.black).padding(.trailing, 10).padding(.bottom, 10)
                                            }.padding(.top, 10).padding(.bottom, 10)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: 320).overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.black, lineWidth: 2)).background(Color.white)
                                    })
                                }.background(Color.white).cornerRadius(10)
                            }.padding(10)
                        }.background(Color.black)
                    }
                }
                .background(Color.black)
                .navigationBarHidden(true)
            }
        }
    }
}

struct Survey {
    let id: String
    let createdBy: String
    let description: String
    let price: String
    let title: String
    let email: String
    let createdAt: TimeInterval
    let surveyImage: String
}

#Preview {
    SurveysView()
}
