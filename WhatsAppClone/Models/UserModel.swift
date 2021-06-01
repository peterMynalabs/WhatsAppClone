

import Foundation

class User {
    static let shared = User(uuid: NSUUID().uuidString)
    let uuid: String
    
    private init(uuid: String) {
        self.uuid = uuid
    }
}
