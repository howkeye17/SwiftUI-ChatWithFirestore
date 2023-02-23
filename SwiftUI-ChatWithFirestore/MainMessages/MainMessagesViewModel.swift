//

import Foundation

class MainMessagesViewModel: ObservableObject {

    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil

    init() {
        fetchCurrentUser()
    }

    private func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find Firebase uid"
            return
        }

        FirebaseManager.shared.firestore
            .collection("users").document(uid).getDocument { snapshot, error in
                if let error = error {
                    debugPrint("Failed to fetch current user:", error)
                    self.errorMessage = "Failed to fetch current user: \(error.localizedDescription)"
                    return
                }
                guard let data = snapshot?.data() else {
                    self.errorMessage = "No Data found"
                    return
                }

                self.chatUser = ChatUser(from: data)
        }
    }

    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }

    func handleSignIn() {
        fetchCurrentUser()
    }
}
