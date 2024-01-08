import SwiftUI

struct SurveyView: View {
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    NavigationLink(destination: QuestionView()) {
                        Image("Sleep").resizable().aspectRatio(contentMode: .fit)
                    }
                    VStack {
                        Text("Status: Active")
                            .foregroundColor(.white)
                    }
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(Color.survaidBlue)
                    .edgesIgnoringSafeArea(.all)
                    Button("Request to Participate") {
                    }
                    .padding(20)
                    .background(Color.survaidBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                    HStack {
                        Image(systemName: "person.fill").foregroundColor(.black).padding(.leading, 10).padding(.top, 10).padding(.bottom, 10)
                        Text("jimbucktoo").foregroundColor(.black).padding(.top, 10)
                        Spacer()
                        Text("Price: $1.99").foregroundColor(.black).padding(.trailing, 10).padding(.top, 10)
                    }
                    HStack {
                        Image(systemName: "person.2.fill").foregroundColor(.black).padding(.leading, 10).padding(.top, 10)
                        Text("10 Comments").foregroundColor(.black).padding(.top, 10)
                        Spacer()
                        Text("10 Participants").foregroundColor(.black).padding(.trailing, 10).padding(.top, 10)
                    }
                    VStack {
                        HStack {
                            Text("Sleep Apnea Survey")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.leading, 10)
                                .padding(.top, 10)
                            Spacer()
                        }
                        VStack {
                            Text("This survey aims to analyze and detect abnormalities in sleep patterns using microphone input. The survey involves utilizing your device's microphone to record ambient sounds while you sleep. The collected audio will be securely processed and analyzed by our advanced algorithms designed to identify potential indicators of sleep apnea, such as irregular breathing patterns, snoring, or pauses in breathing during sleep. To participate, please ensure a quiet sleeping environment and place your device (with a fully charged battery) at a reasonable distance from where you sleep. The survey will require you to enable microphone access and start the recording before falling asleep. Upon waking up, you can end the recording and submit the data for analysis.")
                                .foregroundColor(.black)
                                .padding(.leading, 10)
                                .padding(.top, 2)
                            Spacer()
                        }.frame(maxWidth: .infinity, alignment: .top)
                    }
                }
                .frame(maxHeight: .infinity).overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)).background(Color.white)
            }.background(Color.black).cornerRadius(10)
        }
        .background(Color.black)
        .navigationTitle("Sleep Apnea Survey")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarColor(.black)
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
    SurveyView()
}
