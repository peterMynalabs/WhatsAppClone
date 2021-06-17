//
//  Dialogue.swift
//  WhatsAppClone
//
//  Created by Peter Shaburov on 6/4/21.
//

import Foundation
import RealmSwift

class Dialogue: Object, Codable  {
    @objc dynamic var interlocutor: String?
    @objc dynamic var dialogueID: String?
    @objc dynamic var lastMessage: String?
    
    override init() {
        super.init()
    }
    convenience init(interlocutor: String, dialogueID: String, lastMessage: String) {
        self.init()
        self.interlocutor = interlocutor
        self.dialogueID = dialogueID
        self.lastMessage = lastMessage
    }
    
    override static func primaryKey() -> String? {
            return "dialogueID"
        }
}
