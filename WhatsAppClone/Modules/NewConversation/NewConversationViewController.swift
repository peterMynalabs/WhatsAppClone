//
//  NewConversationViewController.swift
//  WhatsAppClone
//
//  Created by Peter Shaburov on 6/4/21.
//

import Foundation
import UIKit
import SnapKit

protocol NewMessageViewDelegate: AnyObject {
    func presentConversation(user: User)
}

class NewMessageViewController: UIViewController {
    var mainView = UIView()
    var userList: [User]?
    
    weak var newMessageDelegate: NewMessageViewDelegate?
    var userDatabase: UserDatabase?

    
    override func loadView() {
        mainView.frame = UIScreen.main.bounds
        view = mainView
        mainView.backgroundColor = .white
        title = "New Chat"
      
        mainView.addSubview(tableView)

        tableView.snp.makeConstraints({ make -> Void in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(view)
        })
        
        userList = userDatabase?.fetchAllUsers()
        userList?.sort { $0.name! < $1.name! }
    
        UserService().getAllUsers(recievedUsers: { [weak self] users in
            if users.count != 0 {
                self?.userList = users
                self?.userList!.sort { $0.name! < $1.name! }
                DispatchQueue.main.async {
                    self?.recievedUsersFromRemote()
                }
            }
        })
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 46
        tableView.separatorStyle = .none
        return tableView
    }()
    
    func recievedUsersFromRemote() {
        tableView.reloadData()
        userDatabase?.deleteAll()
        for user in userList! {
            userDatabase?.add(user: user)
        }
    }
}

extension NewMessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let userList = userList else {
            return 10
        }
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userList = userList else {
            return UITableViewCell()
        }
        let cell = UITableViewCell()
        
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = .red
            imageView.layer.cornerRadius = 20
            return imageView
        }()
        
        let nameTitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = .black
            label.textAlignment = .left
            return label
        }()
        
        let descriptionTitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 12)
            label.textColor = .lightGray
            label.textAlignment = .left
            return label
        }()
        let seperatorView: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGray
            return view
        }()
        
        nameTitleLabel.text = userList[indexPath.row].name
        descriptionTitleLabel.text = "Avaiable"
        
        cell.addSubview(imageView)
        cell.addSubview(nameTitleLabel)
        cell.addSubview(descriptionTitleLabel)
        cell.addSubview(seperatorView)
        
        imageView.snp.makeConstraints({ make -> Void in
            make.left.equalTo(cell).offset(15)
            make.top.equalTo(cell).offset(4)
            make.size.equalTo(40)
        })
        
        nameTitleLabel.snp.makeConstraints({ make -> Void in
            make.left.equalTo(imageView.snp.right).offset(12)
            make.top.equalTo(10)
            make.width.equalTo(200)
            make.height.equalTo(12)
        })
        
        descriptionTitleLabel.snp.makeConstraints({ make -> Void in
            make.left.equalTo(imageView.snp.right).offset(12)
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(6)
            make.width.equalTo(200)
            make.height.equalTo(9)
        })
        seperatorView.snp.makeConstraints({ make -> Void in
            make.bottom.equalTo(cell)
            make.left.equalTo(cell).offset(65)
            make.width.equalTo(cell)
            make.height.equalTo(0.5)
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: {
            self.newMessageDelegate?.presentConversation(user: self.userList![indexPath.row])
        })
      
    }
}
