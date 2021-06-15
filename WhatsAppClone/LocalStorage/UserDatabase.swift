import Foundation
import RealmSwift

final class UserDatabase {
    
    private let realm: Realm
    
    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    
    func add(user: User) {
        try! realm.write {
            realm.add(user)
        }
    }
    
    func update(with message: String, id: String) {
       
    }
    
    func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func deleteUser(with id: String) {
        guard let object = realm.object(ofType: User.self, forPrimaryKey: id) else {
            return
        }
        
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func fetchUser(with id: String) -> User? {
        return realm.object(ofType: User.self, forPrimaryKey: id)
    }
    
    func fetchAllUsers() -> [User] {
        var x = Array(realm.objects(User.self))
        return x
    }
}
