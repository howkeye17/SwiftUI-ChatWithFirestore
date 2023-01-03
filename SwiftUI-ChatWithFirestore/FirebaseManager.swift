//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManager: NSObject {

    static let shared = FirebaseManager()

    let auth: Auth
    let storage: Storage
    let firestore: Firestore

    private override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        super.init()
    }
}
