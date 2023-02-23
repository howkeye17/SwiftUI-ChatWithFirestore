//

import Foundation

final class CreateNewMessageViewModel: ObservableObject {

    @Published var users = [ChatUser]()
    @Published var errorMessage = ""

    init() {
        fetchAllUsers()
    }

    private func fetchAllUsers() {
        FirebaseManager.shared
            .firestore.collection("users")
            .getDocuments { documentSnapshot, error in
                if let error = error {
                    debugPrint("Failed to fetch users: \(error)")
                    self.errorMessage = "Failed to fetch users: \(error)"
                    return
                }
                documentSnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let user = ChatUser(from: data)
                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(user)
                    }
                })
            }
    }
}
