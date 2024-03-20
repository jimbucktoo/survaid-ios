import SwiftUI

struct EditParticipantInformationView: View {
    @State private var textValue = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
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
    }
}

#Preview {
    EditParticipantInformationView()
}
