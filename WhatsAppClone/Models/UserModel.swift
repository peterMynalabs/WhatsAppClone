

import Foundation
import UIKit
import RealmSwift

class User: Object, Codable {
    @objc dynamic var uid: String?
    @objc dynamic var name: String?
    @objc dynamic var phoneNumber: String?

    override init() {
        super.init()
    }
    
    convenience init(uid: String, name: String, phoneNumber: String) {
        self.init()
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
    
    override static func primaryKey() -> String? {
            return "uid"
        }
}

struct Constants {
    struct UserDefaults {
        static let currentUser = "currentUser"
    }
}
