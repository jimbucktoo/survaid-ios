import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseStorage

enum DragState {
    case inactive
    case dragging(translation: CGSize)
}

struct ChangeProfilePictureView: View {
    let user = Auth.auth().currentUser
    private var dbRef = Database.database().reference()
    private var storageRef = Storage.storage().reference()
    
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var imageURL: URL?
    @State private var userProfile: [String: Any]?
    @State private var dragState = DragState.inactive
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
    
    func loadProfile() {
        dbRef.child("users").observeSingleEvent(of: .value, with: { snapshot in
            if let users = snapshot.value as? [String: Any] {
                for (userId, userData) in users {
                    if userId == user?.uid {
                        self.userProfile = userData as? [String: Any]
                        break
                    }
                }
            }
        })
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
                    Text("Change Profile Picture")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                    Spacer()
                    if let profileData = userProfile {
                        AsyncImage(url: URL(string: "\(profileData["profilePicture"] ?? "")")) { phase in
                            switch phase {
                            case .empty:
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 100))
                                    .foregroundColor(.blue)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.black, lineWidth: 2))
                            case .failure(let error):
                                Text("Failed to load image: \(error.localizedDescription)")
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    Spacer()
                    Text("Please choose an image to upload as your profile picture")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .padding([.leading, .trailing], 10)
                        .multilineTextAlignment(.center)
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
                                Text("Choose an Image")
                                    .padding(20)
                                    .background(Color.survaidOrange)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .sheet(isPresented: $isImagePickerPresented, onDismiss: nil) {
                                ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
                            }
                        }
                    }
                    Button(action: {
                        if let selectedImage = selectedImage {
                            uploadImage(image: selectedImage)
                        } else {
                            self.imageURL = nil
                        }
                    }) {
                        Text("Save")
                            .padding(20)
                            .background(Color.blue)
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
        .onAppear{
            loadProfile()
        }
    }
}

#Preview {
    ChangeProfilePictureView()
}
