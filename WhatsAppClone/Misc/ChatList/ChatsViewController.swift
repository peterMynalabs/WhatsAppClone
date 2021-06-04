//
//  ViewController.swift
//  WhatsAppClone
//
//  Created by Peter Shaburov on 6/1/21.
//

import UIKit
import Foundation
import SnapKit

class ChatsViewController: UIViewController {
    
    var mainView = UIView()
    var dialogues: [Dialogue]?
    
    override func loadView() {
        super.viewDidLoad()
        mainView.frame = UIScreen.main.bounds
        view = mainView
        title = "Chats"
        fetchDialogue(from: "")
        setupNavigationBar()
        mainView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints({ make -> Void in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(view)
        })
    }
    
    func setupNavigationBar() {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tappedNewIcon))
        button.tintColor = UIColor(rgb: 0x007AFF)
        button.image = UIImage(named: "newIcon")
        navigationItem.rightBarButtonItem = button
        navigationItem.leftBarButtonItem = UIBarButtonItem()
    }
    
    func fetchDialogue(from: String) {
        let listofUsers = [User(uid: "1", name: "John", phoneNumber: "0000"),
                           User(uid: "2", name: "Jane", phoneNumber: "0000"),
                           User(uid: "3", name: "Jeremy", phoneNumber: "0000"),
                           User(uid: "4", name: "Jill", phoneNumber: "0000"),
                           User(uid: "5", name: "Jackson", phoneNumber: "0000"),
                           User(uid: "6", name: "Jim", phoneNumber: "0000"),
                           User(uid: "7", name: "Jax", phoneNumber: "0000")]
        var list: [Dialogue] = []
        var counter = 0
        for user in listofUsers {
            counter += 1
            list.append(Dialogue(interlocutor: user, dialogueID: String(counter), lastMessage: "I am gay"))
        }
        
        dialogues = list
    }
    
    var tableView: UITableView = {
        var tableView = UITableView()
        return tableView
    }()
    
    @objc func tappedNewIcon() {
        
    }
}

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogues!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatListTableViewCell
        cell.nameTitleLabel.text = dialogues![indexPath.row].interlocutor.name
        cell.lastMessageTitleLabel.text = dialogues![indexPath.row].lastMessage
    
        return cell
    }
}
