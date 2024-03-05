import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseStorage

struct SurveysView: View {
    @StateObject private var viewModel = SurveysViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
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
                LazyVStack {
                    ForEach(viewModel.surveysData, id: \.id) { survey in
                        let timeDifference = viewModel.calculateTimeDifference(for: survey.createdAt)
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
                                    HStack {
                                        Image(systemName: "person.fill").foregroundColor(.black).padding(.leading, 10).padding(.bottom, 10)
                                        Text("\(survey.email)").foregroundColor(.black)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                            .padding(.bottom, 10)
                                        Spacer()
                                        Text("Price: $\(survey.price)").foregroundColor(.black).padding(.trailing, 10).padding(.bottom, 10)
                                    }
                                    ZStack {
                                        Color.black
                                        AsyncImage(url: URL(string: "\(survey.surveyImage)")) { phase in
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
                                    HStack {
                                        Image(systemName: "text.bubble.fill").foregroundColor(.black).padding(.leading, 10).padding(.top, 10)
                                        Text("Comments").foregroundColor(.black).padding(.top, 10)
                                        Spacer()
                                        Image(systemName: "person.2.fill").foregroundColor(.black).padding(.leading, 10).padding(.top, 10)
                                        Text("Participants").foregroundColor(.black).padding(.trailing, 10).padding(.top, 10)
                                    }.padding(.bottom, 20)
                                }
                                .frame(height: 300).overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 2)).background(Color.white)
                            })
                        }.background(Color.black).cornerRadius(10)
                    }.padding(10)
                }.background(Color.black)
            }
            .background(Color.black)
            .onAppear{
                viewModel.loadSurveys()
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

class SurveysViewModel: ObservableObject {
    @Published var surveysData: [Survey] = []
    
    private var ref = Database.database().reference()
    private var storageRef = Storage.storage().reference()
    
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
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func calculateTimeDifference(for timestamp: TimeInterval) -> String {
        let currentTime = Date().timeIntervalSince1970 * 1000
        let timeDifferenceMinutes = Int(currentTime - timestamp) / 60000
        
        if timeDifferenceMinutes < 60 {
            return "\(timeDifferenceMinutes) m"
        } else if timeDifferenceMinutes < 1440 {
            let hours = timeDifferenceMinutes / 60
            let remainingMinutes = timeDifferenceMinutes % 60
            if remainingMinutes == 0 {
                return "\(hours) hr"
            } else {
                return "\(hours) hr \(remainingMinutes) m"
            }
        } else {
            let days = timeDifferenceMinutes / 1440
            return "\(days) d"
        }
    }
}

#Preview {
    SurveysView()
}
