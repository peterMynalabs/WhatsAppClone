//
//  CreateOrRestoreUserViewController.swift
//  WhatsAppClone
//
//  Created by Peter Shaburov on 6/3/21.
//

import Foundation
import UIKit
import SnapKit

class CreateUserViewController: UIViewController {
   
    var mainView = UIView()
    var imagePicker: ImagePicker!
    var user: User?
    var phoneNumber: String?
    
    override func loadView() {
        mainView.frame = UIScreen.main.bounds
        view = mainView
        mainView.backgroundColor = .white
        title = "Create Profile"
        
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        mainView.addSubview(profileImageView)
        mainView.addSubview(mainTitleLabel)
        mainView.addSubview(editButton)
        mainView.addSubview(nameTextField)
        addBorders()
        setupNavigationBar()
        
        profileImageView.snp.makeConstraints({ (make) -> Void in
            make.left.equalTo(mainView).offset(15)
            make.top.equalTo(mainView).offset(107)
            make.width.equalTo(60)
            make.height.equalTo(60)
        })
        mainTitleLabel.snp.makeConstraints({ (make) -> Void in
            make.left.equalTo(profileImageView.snp.right).offset(15)
            make.top.equalTo(mainView).offset(107)
            make.width.equalTo(mainView)
            make.height.equalTo(60)
        })
        editButton.snp.makeConstraints({ (make) -> Void in
            make.left.equalTo(mainView).offset(15)
            make.top.equalTo(profileImageView.snp.bottom).inset(3)
            make.width.equalTo(60)
            make.height.equalTo(34)
        })
        nameTextField.snp.makeConstraints({ (make) -> Void in
            make.left.equalTo(mainView).offset(15)
            make.top.equalTo(editButton.snp.bottom).offset(5)
            make.width.equalTo(mainView)
            make.height.equalTo(34)
        })
        nameTextField.delegate = self
    }
    
    var profileImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true

        return imageView
    }()
    
    var mainTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "Enter your name and add an optional\nprofile picture"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(rgb: 0x8B898E)
        label.textAlignment = .left
        return label
    }()
    
    var editButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(UIColor(rgb: 0x007AFF), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tappedButton), for: .touchDown)
        return button
    }()
    
    var nameTextField: UITextField = {
        var textView = UITextField()
        textView.placeholder = "Your name"
        textView.keyboardType = .alphabet
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = UIColor(rgb: 0xC7C7CC)
        textView.textAlignment = .left
        textView.backgroundColor = .white
        return textView
    }()
    
    func addBorders() {
        let borderBottom = UIView()
        let borderTop = UIView()
        borderTop.backgroundColor = UIColor(rgb: 0xdbdbdf)
        borderBottom.backgroundColor =  UIColor(rgb: 0xdbdbdf)
        mainView.addSubview(borderBottom)
        mainView.addSubview(borderTop)
        
        borderBottom.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(nameTextField.snp.bottom)
            make.height.equalTo(0.5)
            make.width.equalTo(mainView)
            make.left.equalTo(mainView).offset(15)
        })
        borderTop.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(nameTextField.snp.top)
            make.height.equalTo(0.5)
            make.width.equalTo(mainView)
            make.left.equalTo(mainView).offset(15)
        })
    }
    
    func setupNavigationBar() {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(clickedDone))
        button.tintColor = UIColor(rgb: 0x007AFF)
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], for: UIControl.State.normal)
        navigationItem.rightBarButtonItem = button
        navigationItem.leftBarButtonItem = UIBarButtonItem()
    }
    
    @objc func tappedButton() {
        imagePicker.present(from: mainView)
    }
    
    @objc func clickedDone() {
        user = User(uid: NSUUID().uuidString, name: nameTextField.text!, phoneNumber: phoneNumber!)
        guard let user = user else {
            return
        }
        UserService().uploadUser(with: user)
        navigationController?.setViewControllers([ChatsViewController()], animated: true)
    }
}

extension CreateUserViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 25
    }
}

extension CreateUserViewController: VerificationCodeDelegate {
    func sucess(phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }
}

extension CreateUserViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        profileImageView.image = image
    }
}
