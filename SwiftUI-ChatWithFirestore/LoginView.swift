//

import SwiftUI

struct LoginView: View {

    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var loginStatusMessage = ""
    @State var shouldShowImagePicker = false
    @State var image: UIImage?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {

                    Picker(selection: $isLoginMode) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    } label: {
                        Text("Picker Here")
                    }
                    .pickerStyle(.segmented)

                    if !isLoginMode {
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                .stroke(Color.black, lineWidth: 3))
                        }
                    }
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(.white)

                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }
                        .background(Color.blue)
                    }

                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
        }
        .fullScreenCover(
            isPresented: $shouldShowImagePicker,
            content: {
                ImagePicker(image: $image)
            }
        )
    }

    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }

    private func loginUser() {
        FirebaseManager.shared.auth.signIn(
            withEmail: email,
            password: password,
            completion: { result, error in
                if let error = error {
                    debugPrint("Failed to create user:", error)
                    self.loginStatusMessage = "Failed to login user: \(error)"
                    return
                }
                debugPrint("Successfully logged in as user: \(result?.user.uid ?? "")")
                self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
            }
            )
    }

    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(
            withEmail: email,
            password: password,
            completion: { result, error in
                if let error = error {
                    debugPrint("Failed to create user:", error)
                    self.loginStatusMessage = "Failed to create user: \(error)"
                    return
                }
                debugPrint("Successfully created user: \(result?.user.uid ?? "")")
                self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"

                self.persistImageToStorage()
            }
        )
    }

    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }

        let reference = FirebaseManager.shared.storage.reference(withPath: uid)

        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }

        reference.putData(imageData) { metadata, error in
            if let error = error {
                self.loginStatusMessage = "Failed to push image to Storage: \(error)"
                return
            }

            reference.downloadURL { url, error in
                if let error = error {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(error)"
                    return
                }
                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"

                self.storeUserInformation(imageProfileURL:url)
            }
        }
    }

    private func storeUserInformation(imageProfileURL: URL?) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid,
              let imageProfileURL = imageProfileURL
        else { return }
        let userData = ["email": email, "uid": uid, "imageProfileURL": imageProfileURL.absoluteString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { error in
                if let error = error {
                    self.loginStatusMessage = "\(error)"
                    return
                }
                debugPrint("Success")
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
