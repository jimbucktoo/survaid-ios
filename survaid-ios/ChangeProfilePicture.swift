import SwiftUI

struct ChangeProfilePictureView: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer()
                Text("Change Profile Picture")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.survaidBlue)
                    .multilineTextAlignment(.center)
                Spacer()
                Text("Please take a picture to upload to your participant profile").foregroundColor(.white).font(.system(size: 20)).padding([.leading, .trailing], 10).multilineTextAlignment(.center)
                Spacer()
                HStack {
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
                        .sheet(isPresented: $isImagePickerPresented, onDismiss: nil) {
                            ImagePicker(selectedImage: $selectedImage)
                        }
                    }
                }
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
    ChangeProfilePictureView()
}
