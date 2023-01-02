//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManager: NSObject {

    static let shared = FirebaseManager()

    let auth: Auth
    let storage: Storage

    private override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        super.init()
    }
}
