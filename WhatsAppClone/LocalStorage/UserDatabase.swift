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
        let typeOfObject = realm.objects(User.self)

        try! realm.write {
            realm.delete(typeOfObject)
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
        return Array(realm.objects(User.self))
    }
}
