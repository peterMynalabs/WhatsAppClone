import Foundation
import UIKit
import SnapKit

class ConversationViewController: UIViewController {
    
    var mainView = UIView()
    var interlocutor: User?
    var isDialogueCreated = true
    var dialogue: Dialogue?
    
    override func loadView() {
        mainView.frame = UIScreen.main.bounds
        view = mainView
        title = interlocutor?.name
        setupKeyboardObservers()
        
        if dialogue == nil  {
            isDialogueCreated = false
        }
        
        textView.delegate = self
        
        mainView.addSubview(backgroundImage)
        mainView.addSubview(bottomView)
        bottomView.addSubview(textView)
        bottomView.addSubview(addButton)
        bottomView.addSubview(recordButton)
        bottomView.addSubview(cameraButton)
        bottomView.addSubview(sendButton)
        
        backgroundImage.snp.makeConstraints({ make -> Void in
            make.bottom.equalTo(mainView)
            make.left.equalTo(mainView)
            make.size.equalTo(mainView)
        })
        bottomView.snp.makeConstraints({ make -> Void in
            make.bottom.equalTo(mainView.snp.bottom)
            make.left.equalTo(mainView.snp.left)
            make.width.equalTo(mainView)
            make.height.equalTo(80)
        })
        textView.snp.makeConstraints({ make -> Void in
            make.top.equalTo(bottomView.snp.top).inset(6)
            make.left.equalTo(bottomView.snp.left).inset(47)
            make.width.equalTo(228)
            make.height.equalTo(32)
        })
        addButton.snp.makeConstraints({ make -> Void in
            make.top.equalTo(bottomView.snp.top).offset(10)
            make.left.equalTo(bottomView.snp.left).inset(14)
            make.size.equalTo(19)
        })
        cameraButton.snp.makeConstraints({ make -> Void in
            make.top.equalTo(bottomView.snp.top).offset(11)
            make.left.equalTo(textView.snp.right).offset(19)
            make.width.equalTo(22)
            make.height.equalTo(19)
        })
        recordButton.snp.makeConstraints({ make -> Void in
            make.top.equalTo(bottomView.snp.top).offset(9)
            make.left.equalTo(cameraButton.snp.right).offset(22)
            make.width.equalTo(16)
            make.height.equalTo(24)
        })
        sendButton.snp.makeConstraints({ make -> Void in
            make.top.equalTo(bottomView.snp.top).offset(5)
            make.left.equalTo(textView.snp.right).offset(8)
            make.size.equalTo(31)
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    var backgroundImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "CoversationBackground")
        return imageView
    }()
    
    var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xF6F6F6)
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    var textView: UITextView = {
        var textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .left
        textView.textContainerInset.left = 5
        textView.keyboardType = .default
        textView.layer.cornerRadius = 16
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        return textView
    }()
    
    var addButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "Add"), for: .normal)
        return button
    }()
    var recordButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "recordAudio"), for: .normal)
        return button
    }()
    
    var cameraButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "Camera"), for: .normal)
        return button
    }()
    
    var sendButton: UIButton = {
        var button = UIButton()
        button.isHidden = true
        button.addTarget(self, action: #selector(clickedSend), for: .touchDown)
        button.setImage(UIImage(named: "send"), for: .normal)
        return button
    }()
    
    func createDialogue(message: String) {
        if !isDialogueCreated {
            let id = User.current!.uid + interlocutor!.uid
            dialogue = Dialogue(interlocutor: interlocutor!, dialogueID: String(id.hash), lastMessage: message)
            isDialogueCreated = true
        } else {
            dialogue?.lastMessage = message
        }
    }
    
    @objc func clickedSend() {
        createDialogue(message: textView.text)
        textView.text = ""
        edit()
    }
    
   @objc func keyboardWillAppear(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.mainView.frame.origin.y == 0 {
                self.mainView.frame.origin.y -= keyboardSize.height - 34
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.mainView.frame.origin.y = 0

    }
    
    func edit() {
        if textView.text!.count == 0 {
            cameraButton.isHidden = false
            recordButton.isHidden = false
            sendButton.isHidden = true
            textView.snp.updateConstraints({ make -> Void in
                make.width.equalTo(228)
            })
        } else {
            cameraButton.isHidden = true
            recordButton.isHidden = true
            sendButton.isHidden = false

            textView.snp.updateConstraints({ make -> Void in
                make.width.equalTo(287)
            })
        }
    }
}

extension ConversationViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        edit()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            textView.text = ""
            edit()
            return false
        }
        return true
    }
}
