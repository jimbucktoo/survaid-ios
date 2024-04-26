import SwiftUI
import AVFoundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseStorage

struct QuestionView: View {
    private var dbRef = Database.database().reference()
    private var storageRef = Storage.storage().reference()
    let surveyId: String?
    
    @State private var isLoading = true
    @State private var textValue = ""
    @State private var sliderValue = 5.0
    @State private var minInput = 1.0
    @State private var maxInput = 10.0
    @State private var interval = 1.0
    @State private var selectedRadio = 0
    @State private var pickerValue = 5
    @State private var options = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @State private var audioRecorder: AVAudioRecorder!
    @State private var isRecording = false
    @State private var recordingDuration: TimeInterval = 0.0
    @State private var timer: Timer?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var audioRef: URL?
    @State private var audioURL: URL?
    @State private var imageURL: URL?
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var questionIndex = 0
    @State private var selectedQuestionType: String = ""
    @State private var surveyQuestions: [SurveyQuestion] = []
    @State private var answers: [Any] = []
    @State private var dragState = DragState.inactive
    @Environment(\.dismiss) private var dismiss
    
    init(surveyId: String? = nil) {
        self.surveyId = surveyId
    }
    
    func uploadImage(image: UIImage, completion: @escaping () -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image to data")
            return
        }
        
        let imageName = "\(Date().timeIntervalSince1970).jpg"
        let imageRef = storageRef.child("images/data/\(surveyId ?? "")/\(imageName)")
        
        _ = imageRef.putData(imageData, metadata: nil) { metadata, error in
            guard let _ = metadata else {
                print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            imageRef.downloadURL { (url, error) in
                if let downloadURL = url {
                    self.imageURL = downloadURL
                    print("Image uploaded successfully. Download URL: \(downloadURL)")
                    completion()
                } else {
                    print("Failed to get download URL for image: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    func uploadRecording(completion: @escaping () -> Void) {
        let recordingRef = storageRef.child("audio/data/\(Date().timeIntervalSince1970).m4a")
        
        _ = recordingRef.putFile(from: audioRef!, metadata: nil) { metadata, error in
            if let _ = metadata {
                recordingRef.downloadURL { (url, error) in
                    if let downloadURL = url {
                        self.audioURL = downloadURL
                        print("Recording uploaded successfully. Download URL: \(downloadURL)")
                        completion()
                    } else {
                        print("Failed to get download URL for recording: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            } else {
                print("Error uploading recording: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func handleSubmit() {
        print("Answers: \(answers)")
        appendAnswer {
            let user = Auth.auth().currentUser
            dbRef.child("surveys").child(surveyId ?? "").child("answers").child(user?.uid ?? "").setValue(answers) { error, _ in
                if let error = error {
                    print("Error setting answers: \(error.localizedDescription)")
                } else {
                    print("Answers set successfully")
                    dbRef.child("surveys/\(surveyId ?? "")/status/\(user?.uid ?? "")").setValue("Completed") { error, _ in
                        if let error = error {
                            print("Error updating status: \(error.localizedDescription)")
                        } else {
                            print("Status updated successfully")
                        }
                    }
                    dismiss()
                }
            }
        }
    }
    
    func appendAnswer(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        switch selectedQuestionType {
        case "Text":
            print("Text: \(textValue)")
        case "Slider":
            print("Slider: \(sliderValue)")
        case "Multiple Choice":
            print("Multiple Choice: \(pickerValue)")
        case "Microphone":
            if isRecording {
                stopRecording()
                dispatchGroup.enter()
                uploadRecording {
                    dispatchGroup.leave()
                }
            } else {
                dispatchGroup.enter()
                uploadRecording {
                    dispatchGroup.leave()
                }
            }
        case "Camera":
            if let selectedImage = selectedImage {
                dispatchGroup.enter()
                uploadImage(image: selectedImage) {
                    dispatchGroup.leave()
                }
            } else {
                self.imageURL = nil
                dispatchGroup.enter()
                dispatchGroup.leave()
            }
        default:
            print("No Selected Question Type")
        }
        
        dispatchGroup.notify(queue: .main) {
            var answer: [String: Any] = [:]
            switch self.selectedQuestionType {
            case "Text":
                answer["value"] = self.textValue
            case "Slider":
                answer["value"] = self.sliderValue
            case "Multiple Choice":
                answer["value"] = self.pickerValue
            case "Microphone":
                answer["value"] = self.audioURL?.absoluteString ?? ""
            case "Camera":
                answer["value"] = self.imageURL?.absoluteString ?? ""
            default:
                break
            }
            answer["questionIndex"] = self.questionIndex
            answer["type"] = self.selectedQuestionType
            self.answers.append(answer)
            completion()
        }
    }
    
    func getValueForCurrentQuestion() -> Any {
        switch selectedQuestionType {
        case "Text":
            return textValue
        case "Slider":
            return sliderValue
        case "Multiple Choice":
            return pickerValue
        case "Microphone":
            return audioURL?.absoluteString ?? ""
        case "Camera":
            return imageURL?.absoluteString ?? ""
        default:
            return ""
        }
    }
    
    func readValue() {
        isLoading = true
        dbRef.child("surveys/\(surveyId ?? "")/questions").observeSingleEvent(of: .value, with: { snapshot in
            if let surveyData = snapshot.value as? NSArray {
                var questions = [SurveyQuestion]()
                for data in surveyData {
                    if let questionData = data as? NSDictionary {
                        if let title = questionData["title"], let description = questionData["description"], let type = questionData["type"] {
                            let question = SurveyQuestion(title: title as! String, description: description as! String, type: type as! String)
                            questions.append(question)
                        }
                    }
                }
                self.surveyQuestions = questions
                resetInputValues()
                isLoading = false
            } else {
                print("Unable to access data or data is not in NSArray or NSDictionary format.")
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    var currentQuestion: SurveyQuestion {
        return surveyQuestions[questionIndex]
    }
    
    func previousQuestion() {
        if questionIndex > 0 {
            questionIndex -= 1
            resetInputValues()
        }
    }
    
    func nextQuestion() {
        appendAnswer {
            if questionIndex < surveyQuestions.count - 1 {
                questionIndex += 1
                resetInputValues()
            } else {
                handleSubmit()
            }
        }
    }
    
    func resetInputValues() {
        selectedQuestionType = surveyQuestions[questionIndex].type
    }
    
    func startRecording() {
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
        audioRecorder.stop()
        isRecording = false
        timer?.invalidate()
        timer = nil
        recordingDuration = 0.0
        audioRef = audioRecorder.url
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
    
    private func onDragChanged(drag: DragGesture.Value) {
        if drag.translation.width > 100 {
            dismiss()
        }
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        self.dragState = .inactive
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading {
                    Color.black.ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2.0)
                } else {
                    Color.black.ignoresSafeArea()
                    VStack {
                        Spacer()
                        Text(currentQuestion.title)
                            .font(.title)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding([.leading, .trailing], 20)
                        Text(currentQuestion.description)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding([.leading, .trailing], 20)
                        Spacer()
                        switch selectedQuestionType {
                        case "Text":
                            TextField("",
                                      text: $textValue,
                                      prompt: Text("Write a Response...")
                                .foregroundColor(.black)
                            ).frame(width: 300, height: 50, alignment: .center).background(Color.white).cornerRadius(10).multilineTextAlignment(.center).foregroundColor(.black)
                            
                        case "Slider":
                            Text("Slider Value: \(Int(sliderValue))")
                                .foregroundColor(.white)
                            Slider(value: $sliderValue, in: minInput...maxInput, step: interval)
                                .padding([.leading, .trailing], 20)
                            
                        case "Multiple Choice":
                            Picker(selection: $pickerValue, label: Text("Multiple Choice")) {
                                ForEach(options, id: \.self) { option in
                                    Text("\(option)").foregroundColor(Color.white)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            
                        case "Microphone":
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
                                            .foregroundColor(.blue)
                                            .padding(1)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                    }
                                    Spacer()
                                }
                            }
                            
                        case "Camera":
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
                                    ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
                                }
                            }
                        default:
                            Spacer()
                        }
                        Spacer()
                        VStack {
                            if questionIndex != 0 {
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
                                    handleSubmit()
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
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Survey")
                }
            }
            )
            .onAppear {
                readValue()
            }
            .gesture(
                DragGesture()
                    .onChanged(onDragChanged)
                    .onEnded(onDragEnded)
            )
        }
    }
    
    private func loadImage() {
    }
}

struct SurveyQuestion {
    let title: String
    let description: String
    let type: String
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType
    
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
        picker.sourceType = sourceType
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}

#Preview {
    QuestionView(surveyId: "-NstKg4GUvuAyxN2WLhk")
}
