import SwiftUI

struct QuestionView: View {
    enum InputType {
        case textInput, slider, multipleChoice, recording
    }
    
    @State private var selectedInputType: InputType = .recording
    @State private var sliderValue = 5.0
    @State private var minInput = 1.0
    @State private var maxInput = 5.0
    @State private var interval = 1.0
    @State private var selectedRadio = 0
    @State private var textInputValue = ""
    @State private var pickerValue = 2
    @State private var options = [1, 2, 3, 4, 5]
    
    @State private var recordingTime = 5
    @State private var isRecording = false
    @State private var timer: Timer?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    Spacer()
                    Text("Quality of sleep in the past week")
                        .font(.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing], 20)
                    Spacer()
                    Text("Please enter your quality of sleep over the past week")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding([.leading, .trailing], 20)
                    Spacer()
                    Picker("Select Input Type", selection: $selectedInputType) {
                        Text("Text Input").tag(InputType.textInput)
                        Text("Slider").tag(InputType.slider)
                        Text("Multiple Choice").tag(InputType.multipleChoice)
                        Text("Recording").tag(InputType.recording)
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal, 40)
                    .foregroundColor(.white)
                    Spacer()
                    
                    switch selectedInputType {
                    case .textInput:
                        TextField("Enter Response Here", text: $textInputValue)
                            .padding([.leading, .trailing], 20)
                            .foregroundColor(.black)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        
                    case .slider:
                        Text("Slider Value: \(Int(sliderValue))")
                            .foregroundColor(.white)
                        Slider(value: $sliderValue, in: minInput...maxInput, step: interval)
                            .padding([.leading, .trailing], 20)
                        
                    case .multipleChoice:
                        Picker(selection: $pickerValue, label: Text("Multiple Choice")) {
                            ForEach(0 ..< options.count, id: \.self) { index in
                                Text("\(self.options[index])").foregroundColor(Color.white)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    
                    case .recording:
                        VStack {
                            if isRecording {
                                Text(recordingTime > 0 ? "Recording Time: \(recordingTime) seconds" : "Recording Completed")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 20)
                            } else {
                                Text(recordingTime > 0 ? "Start Recording" : "Recording Completed")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 20)
                            }
                            
                            if isRecording {
                                Button(action: {
                                    startRecording()
                                }) {
                                    Image(systemName: "stop.circle.fill")
                                        .font(.system(size: 70))
                                        .foregroundColor(.red)
                                        .padding(1)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                if recordingTime > 0 {
                                    Button(action: {
                                        startRecording()
                                    }) {
                                        Image(systemName: "circle.fill")
                                            .font(.system(size: 70))
                                            .foregroundColor(.red)
                                            .padding(1)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                    }
                                } else {
                                    Button(action: {
                                        startRecording()
                                    }) {
                                        Image(systemName: "arrow.counterclockwise.circle.fill")
                                            .font(.system(size: 70))
                                            .foregroundColor(.red)
                                            .padding(1)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                    Button("Next Question") {
                    }
                    .padding(20)
                    .background(Color.survaidBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                    Spacer()
                }
            }
        }
    }
    
    func startRecording() {
        recordingTime = 5
        isRecording.toggle()
        if isRecording {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if recordingTime > 0 {
                    recordingTime -= 1
                } else {
                    stopRecording()
                }
            }
        }
    }
    
    func stopRecording() {
        isRecording = false
        timer?.invalidate()
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}
