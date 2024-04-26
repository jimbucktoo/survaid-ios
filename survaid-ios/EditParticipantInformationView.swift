import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseStorage

struct EditParticipantInformationView: View {
    let user = Auth.auth().currentUser
    private var dbRef = Database.database().reference()
    private var storageRef = Storage.storage().reference()
    
    @State private var textValue = ""
    @State private var dragState = DragState.inactive
    @Environment(\.dismiss) private var dismiss
    
    func updateParticipantInformation() {
        if (textValue != ""){
            dbRef.child("users/\(user?.uid ?? "")/participantInformation").setValue(textValue)
        }
        print("Updated Participant Information")
        dismiss()
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
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    Text("Edit Participant Information")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.survaidBlue)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text("Please tell us about yourself to showcase what kind of a participant you are!").foregroundColor(.white).font(.system(size: 20)).padding([.leading, .trailing], 10).multilineTextAlignment(.center)
                    Spacer()
                    TextField("",
                              text: $textValue,
                              prompt: Text("")
                        .foregroundColor(.black)
                    ).frame(width: 300, height: 50, alignment: .center).background(Color.white).cornerRadius(10).multilineTextAlignment(.center).foregroundColor(.black)
                    Spacer()
                    Button(action: {
                        updateParticipantInformation()
                    }) {
                        Text("Save")
                            .padding(20)
                            .background(Color.survaidBlue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
                .padding(.horizontal, 20)
            }
            .background(Color.black)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Settings")
                }
            })
            .gesture(
                DragGesture()
                    .onChanged(onDragChanged)
                    .onEnded(onDragEnded)
            )
        }
    }
}

#Preview {
    EditParticipantInformationView()
}
