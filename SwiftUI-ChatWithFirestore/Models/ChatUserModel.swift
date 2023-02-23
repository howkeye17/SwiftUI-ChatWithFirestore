//

import Foundation

struct ChatUser {
    let uid: String
    let email: String
    let imageProfileURL: String

    init(from data: [String: Any]) {
        uid = data["uid"] as? String ?? ""
        email = data["email"] as? String ?? ""
        imageProfileURL = data["imageProfileURL"] as? String ?? ""
    }
}
