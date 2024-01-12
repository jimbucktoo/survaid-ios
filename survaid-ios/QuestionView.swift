import SwiftUI
import AVFoundation
import UIKit

struct QuestionView: View {
    
    struct SurveyQuestion {
        enum QuestionType {
            case textInput, slider, multipleChoice, recording, imageCapture
        }
        
        let type: QuestionType
        let prompt: String
    }
    @State private var selectedQuestionType: SurveyQuestion.QuestionType
    
    init() {
        _selectedQuestionType = State(initialValue: surveyQuestions.first?.type ?? .imageCapture)
    }
    @State private var sliderValue = 5.0
    @State private var minInput = 1.0
    @State private var maxInput = 10.0
    @State private var interval = 1.0
    @State private var selectedRadio = 0
    @State private var textInputValue = ""
    @State private var pickerValue = 2
    @State private var options = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    @State private var audioRecorder: AVAudioRecorder!
    @State private var isRecording = false
    @State private var recordingDuration: TimeInterval = 0.0
    @State private var timer: Timer?
    @State private var audioPlayer: AVAudioPlayer?
    
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    
    @State private var questionIndex = 0
    
    let surveyQuestions: [SurveyQuestion] = [
        SurveyQuestion(type: .textInput, prompt: "Describe your quality of sleep over the past week."),
        SurveyQuestion(type: .multipleChoice, prompt: "On a scale of 1 to 10, how would you rate your stress level?"),
        SurveyQuestion(type: .slider, prompt: "On a scale of 1 to 10, how would you rate your sleep?"),
        SurveyQuestion(type: .recording, prompt: "Record your sleep session"),
        SurveyQuestion(type: .imageCapture, prompt: "Take a picture of your sleeping environment"),
    ]
    
    var currentQuestion: SurveyQuestion {
        return surveyQuestions[questionIndex]
    }
    
    func previousQuestion() {
        print("Previous Question")
        if questionIndex > 0 {
            questionIndex -= 1
            resetInputValues()
        }
    }
    
    func nextQuestion() {
        print("Next Question")
        if questionIndex < surveyQuestions.count - 1 {
            questionIndex += 1
            resetInputValues()
        }
    }
    
    func resetInputValues() {
        selectedQuestionType = surveyQuestions[questionIndex].type
    }
    
    func startRecording() {
        print("Starting Recording")
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)
            
            let audioSettings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("recording.m4a"), settings: audioSettings)
            audioRecorder.record()
            isRecording = true
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.recordingDuration += 1.0
            }
        } catch {
            print("Error recording audio: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        print("Stopping Recording")
        audioRecorder.stop()
        isRecording = false
        timer?.invalidate()
        timer = nil
        recordingDuration = 0.0
    }
    
    func playRecording() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: audioRecorder.url)
            audioPlayer?.play()
        } catch let error {
            print("Error initializing audio player: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Spacer()
                Text("Question \(questionIndex + 1)")
                    .font(.title)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing], 20)
                Spacer()
                Text(currentQuestion.prompt)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .padding([.leading, .trailing], 20)
                Spacer()
                switch selectedQuestionType {
                case .textInput:
                    TextField("Enter Response Here", text: $textInputValue)
                        .padding([.leading, .trailing], 20)
                        .foregroundColor(.white)
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
                        Text(String(format: "%.1f Seconds", recordingDuration))
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        HStack {
                            Spacer()
                            Button(action: {
                                if isRecording {
                                    stopRecording()
                                } else {
                                    startRecording()
                                }
                            }) {
                                Image(systemName: isRecording ? "stop.circle.fill" : "circle.fill")
                                    .font(.system(size: 70))
                                    .foregroundColor(.red)
                                    .padding(1)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            Button(action: {
                                playRecording()
                            }) {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 70))
                                    .foregroundColor(.survaidBlue)
                                    .padding(1)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            Spacer()
                        }
                    }
                    
                case .imageCapture:
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        Button(action: {
                            isImagePickerPresented.toggle()
                        }) {
                            Image(systemName: "camera.circle.fill")
                                .font(.system(size: 70))
                                .foregroundColor(.white)
                                .padding(1)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        .sheet(isPresented: $isImagePickerPresented, onDismiss: loadImage) {
                            ImagePicker(selectedImage: $selectedImage)
                        }
                    }
                }
                Spacer()
                VStack {
                    if questionIndex == 0 {
                        
                    } else {
                        Button(action: {
                            previousQuestion()
                        }) {
                            Text("Previous Question")
                                .padding(20)
                                .background(Color.survaidOrange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(0)
                        }
                    }
                    
                    Button(action: {
                        if questionIndex == surveyQuestions.count - 1 {
                            print("Survey Submitted")
                        } else {
                            nextQuestion()
                        }
                    }) {
                        Text(questionIndex == surveyQuestions.count - 1 ? "Submit Survey" : "Next Question")
                            .padding(20)
                            .background(Color.survaidBlue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(0)
                    }
                }
                Spacer()
            }
        }
    }
    
    private func loadImage() {
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}
