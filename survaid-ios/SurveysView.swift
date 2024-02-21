import SwiftUI
import FirebaseAuth

struct SurveysView: View {
    
    let user = Auth.auth().currentUser
    
    init() {
        if let user = user {
            print(user.email ?? "User Not Authenticated")
        }
    }
    
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
                    ForEach(1...4, id: \.self) { row in
                        HStack {
                            NavigationLink(destination: SurveyView(), label: {
                                VStack {
                                    HStack {
                                        Image(systemName: "doc.fill").foregroundColor(.survaidBlue).padding(.leading, 10).padding(.bottom, 10)
                                        Text("Sleep Apnea Survey").foregroundColor(.survaidBlue).fontWeight(.bold).padding(.bottom, 10)
                                        Spacer()
                                        Text("\(row) min").foregroundColor(.survaidOrange).fontWeight(.bold).padding(.trailing, 10).padding(.bottom, 10)
                                    }
                                    HStack {
                                        Image(systemName: "person.fill").foregroundColor(.black).padding(.leading, 10).padding(.bottom, 10)
                                        Text("jimbucktoo").foregroundColor(.black).padding(.bottom, 10)
                                        Spacer()
                                        Text("Price: $\(row).99").foregroundColor(.black).padding(.trailing, 10).padding(.bottom, 10)
                                    }
                                    Image("Sleep").resizable().aspectRatio(contentMode: .fit)
                                    HStack {
                                        Image(systemName: "person.2.fill").foregroundColor(.black).padding(.leading, 10).padding(.top, 10)
                                        Text("\(row) Comments").foregroundColor(.black).padding(.top, 10)
                                        Spacer()
                                        Text("\(row) Participants").foregroundColor(.black).padding(.trailing, 10).padding(.top, 10)
                                    }
                                }
                                .frame(height: 300).overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 2)).background(Color.white)
                            })
                        }.background(Color.black).cornerRadius(10)
                    }.padding(10)
                }.background(Color.black)
            }.background(Color.black)
        }
    }
}

#Preview {
    SurveysView()
}
