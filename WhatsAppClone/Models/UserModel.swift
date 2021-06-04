

import Foundation
import UIKit

class User: Codable {
    let uid: String
    var name: String
    var phoneNumber: String

    init(uid: String, name: String, phoneNumber: String) {
        self.uid = uid
        self.name = name
        self.phoneNumber = phoneNumber
    }

    private static var _current: User?

    static var current: User? {
        return _current
    }

    // MARK: - Class Methods
    static func setCurrent(_ user: User, saveToDefaults: Bool = false) {
        if saveToDefaults {
            if let data = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
            }
        }
        _current = user
    }

    static func setCurrent(_ user: User) {
        _current = user
    }
}

struct Constants {
    struct UserDefaults {
        static let currentUser = "currentUser"
    }
}
