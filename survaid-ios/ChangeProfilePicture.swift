import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseStorage

struct ChangeProfilePictureView: View {
    let user = Auth.auth().currentUser
    private var dbRef = Database.database().reference()
    private var storageRef = Storage.storage().reference()
    
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var imageURL: URL?
    @Environment(\.dismiss) private var dismiss
    
    func uploadImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image to data")
            return
        }
        
        let imageRef = storageRef.child("images/users/\(user?.uid ?? "")/profile")
        
        _ = imageRef.putData(imageData, metadata: nil) { metadata, error in
            guard let _ = metadata else {
                print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            imageRef.downloadURL { (url, error) in
                if let downloadURL = url {
                    self.imageURL = downloadURL
                    dbRef.child("users/\(user?.uid ?? "")/profilePicture").setValue(downloadURL.absoluteString) { error, _ in
                        if let error = error {
                            print("Error updating profile picture: \(error.localizedDescription)")
                        } else {
                            print("Profile picture updated successfully")
                            dismiss()
                        }
                    }
                    print("Image uploaded successfully. Download URL: \(downloadURL)")
                } else {
                    print("Failed to get download URL for image: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
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
                            Image(systemName: "photo.fill")
                                .font(.system(size: 70))
                                .foregroundColor(.white)
                                .padding(1)
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .sheet(isPresented: $isImagePickerPresented, onDismiss: nil) {
                            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
                        }
                    }
                }
                Spacer()
                Button(action: {
                    if let selectedImage = selectedImage {
                        uploadImage(image: selectedImage)
                    } else {
                        self.imageURL = nil
                    }
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
