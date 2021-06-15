//
//  DialogueStorage.swift
//  WhatsAppClone
//
//  Created by Peter Shaburov on 6/15/21.
//

import Foundation
import RealmSwift

final class DialogueDatabase {
    
    private let realm: Realm
    
    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    
    func addDialogue(dialogue: Dialogue) {
        try! realm.write {
            realm.add(dialogue)
        }
    }
    
    func update(with message: String, id: String) {
        let object = realm.object(ofType: Dialogue.self, forPrimaryKey: id)
        try! realm.write({
            object?.lastMessage = message
        })
    }
    
    func deleteDialogue(with id: String) {
        guard let object = realm.object(ofType: Dialogue.self, forPrimaryKey: id) else {
            return
        }
        
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func fetchDialogue(with id: String) -> Dialogue? {
        return realm.object(ofType: Dialogue.self, forPrimaryKey: id)
    }
    func fetchAllDialogues() -> [Dialogue] {
        return Array(realm.objects(Dialogue.self))
    }
}
