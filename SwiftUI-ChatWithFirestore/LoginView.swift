//

import SwiftUI

struct LoginView: View {

    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var loginStatusMessage = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {

                    Picker(
                        selection: $isLoginMode
                    ) {
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

                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
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
            }
        )
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
