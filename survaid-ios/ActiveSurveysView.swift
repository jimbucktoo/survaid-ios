import SwiftUI

struct ActiveSurveysView: View {
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
                ForEach(1...4, id: \.self) { row in
                    Divider().background(Color.white)
                    NavigationLink(destination: SurveyView()) {
                        HStack {
                            Image("Sleep")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                            VStack {
                                Text("Sleep Apnea Survey")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .padding(.top, 4)
                                    .padding(.leading, 4)
                                Spacer()
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
            }
        }.background(Color.black)
    }
}

#Preview {
    ActiveSurveysView()
}
