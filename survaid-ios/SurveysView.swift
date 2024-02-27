import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift

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
                        HStack {
                            NavigationLink(destination: SurveyView(), label: {
                                VStack {
                                    HStack {
                                        Image(systemName: "doc.fill").foregroundColor(.survaidBlue).padding(.leading, 10).padding(.bottom, 10)
                                        Text("\(survey.title)").foregroundColor(.survaidBlue).fontWeight(.bold).padding(.bottom, 10)
                                        Spacer()
                                        Text("1 min").foregroundColor(.survaidOrange).fontWeight(.bold).padding(.trailing, 10).padding(.bottom, 10)
                                    }
                                    HStack {
                                        Image(systemName: "person.fill").foregroundColor(.black).padding(.leading, 10).padding(.bottom, 10)
                                        Text("\(survey.email)").foregroundColor(.black).padding(.bottom, 10)
                                        Spacer()
                                        Text("Price: $\(survey.price)").foregroundColor(.black).padding(.trailing, 10).padding(.bottom, 10)
                                    }
                                    Image("Sleep").resizable().aspectRatio(contentMode: .fit)
                                    HStack {
                                        Image(systemName: "text.bubble.fill").foregroundColor(.black).padding(.leading, 10).padding(.top, 10)
                                        Text("Comments").foregroundColor(.black).padding(.top, 10)
                                        Spacer()
                                        Image(systemName: "person.2.fill").foregroundColor(.black).padding(.leading, 10).padding(.top, 10)
                                        Text("Participants").foregroundColor(.black).padding(.trailing, 10).padding(.top, 10)
                                    }
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

#Preview {
    SurveysView()
}

struct Survey {
    let id: String
    let createdBy: String
    let description: String
    let price: String
    let title: String
    let email: String
}

class SurveysViewModel: ObservableObject {
    @Published var surveysData: [Survey] = []
    
    private var ref = Database.database().reference()
    private let user = Auth.auth().currentUser
    
    init() {
        if let user = user {
            print(user.email ?? "User Not Authenticated")
        }
    }
    
    func loadSurveys() {
        ref.child("surveys").observeSingleEvent(of: .value, with: { snapshot in
            if let surveys = snapshot.value as? [String: Any] {
                for (key, value) in surveys {
                    if let surveyData = value as? [String: Any] {
                        let createdBy = surveyData["createdBy"] as? String ?? ""
                        let description = surveyData["description"] as? String ?? ""
                        let price = surveyData["price"] as? String ?? ""
                        let title = surveyData["title"] as? String ?? ""
                        
                        self.ref.child("users").observeSingleEvent(of: .value, with: { userSnapshot in
                            if let users = userSnapshot.value as? [String: Any] {
                                for (userId, userData) in users {
                                    if let userDataDict = userData as? [String: Any], userId == createdBy {
                                        let email = userDataDict["email"] as? String ?? ""
                                        let survey = Survey(id: key, createdBy: createdBy, description: description, price: price, title: title, email: email)
                                        self.surveysData.append(survey)
                                        break
                                    }
                                }
                            }
                        }) { error in
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
}
