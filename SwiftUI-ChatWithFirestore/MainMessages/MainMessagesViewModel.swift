//

import Foundation

class MainMessagesViewModel: ObservableObject {

    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?

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

                guard  let uid = data["uid"] as? String,
                       let email = data["email"] as? String,
                       let imageProfileURL = data["imageProfileURL"] as? String
                else { return }

                self.chatUser = ChatUser(uid: uid, email: email, imageProfileURL: imageProfileURL)
        }
    }
}
