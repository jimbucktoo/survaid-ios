import SwiftUI

struct QuestionView: View {
    
    @State private var sliderValue = 5.0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                HStack {
                    VStack (alignment: .center) {
                        Spacer()
                        Text("Rate your quality of sleep in the past week")
                            .font(.title)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding([.leading, .trailing], 20)
                        Text("Please move the slider to how you would rate your quality of sleep over the past week")
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding([.leading, .trailing], 20)
                        Spacer()
                        VStack {
                            Text("Slider Value: \(Int(sliderValue))")
                                .foregroundColor(.white)
                            Slider(value: $sliderValue, in: 1...10, step: 1)
                                .padding([.leading, .trailing], 20)
                        }
                        Spacer()
                        Button("Next Question") {
                            
                        }
                        .padding(20)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                        Spacer()
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    QuestionView()
}

