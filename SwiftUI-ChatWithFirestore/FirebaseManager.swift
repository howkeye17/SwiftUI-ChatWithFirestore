//

import Foundation
import Firebase

class FirebaseManager: NSObject {

    static let shared = FirebaseManager()

    let auth: Auth

    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        super.init()
    }
}
