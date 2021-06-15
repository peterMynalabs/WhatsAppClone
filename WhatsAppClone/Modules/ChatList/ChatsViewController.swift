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
    var dialogueDatabase: DialogueDatabase?
    var userDatabase: UserDatabase?

    override func loadView() {
        super.viewDidLoad()
        mainView.frame = UIScreen.main.bounds
        view = mainView
        title = "Chats"
        fetchDialogue()
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
    override func viewDidAppear(_ animated: Bool) {
        fetchDialogue()
        tableView.reloadData()
    }
    
    func setupNavigationBar() {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tappedNewIcon))
        button.tintColor = UIColor(rgb: 0x007AFF)
        button.image = UIImage(named: "newIcon")
        navigationItem.rightBarButtonItem = button
        navigationItem.leftBarButtonItem = UIBarButtonItem()
    }
    
    func fetchDialogue() {
        dialogues = dialogueDatabase?.fetchAllDialogues()
    }
    
    var tableView: UITableView = {
        var tableView = UITableView()
        return tableView
    }()
    
    func routeToChat(with dialogue: Dialogue){
        let controller = ConversationViewController()
        controller.interlocutor = dialogue.interlocutor
        controller.dialogue = dialogue
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func tappedNewIcon() {
        let controller = NewMessageViewController()
        controller.userDatabase = userDatabase
        controller.newMessageDelegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
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
        cell.nameTitleLabel.text = dialogues![indexPath.row].interlocutor?.name
        cell.lastMessageTitleLabel.text = dialogues![indexPath.row].lastMessage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        routeToChat(with: dialogues![indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ChatsViewController: NewMessageViewDelegate {
    func presentConversation(user: User) {
        //need a check to see wether conversation already exists or no
        let controller = ConversationViewController()
        controller.interlocutor = user
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

