
import Foundation
import UIKit
import SnapKit
import FirebaseAuth


protocol VerificationCodeDelegate: class {
    func sucess(phoneNumber: String)
}

class VerificationCodeViewController: VC {
    var mainView = UIView()
    var recievedVerificationCode: String?
    
    weak var verificationDelegate: VerificationCodeDelegate?
    
    override func loadView() {
        mainView.frame = UIScreen.main.bounds
        view = mainView
        mainView.backgroundColor = .white
        mainView.addSubview(mainTitleLabel)
        mainView.addSubview(verificationCodeTextField)
        mainView.addSubview(verifyCodeButton)
        mainTitleLabel.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(60)
            make.top.equalTo(mainView).offset(107)
            make.centerX.equalToSuperview()
        })
        verificationCodeTextField.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(mainView)
            make.height.equalTo(45)
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(19)
            make.left.equalTo(mainView)
        })
        verifyCodeButton.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(mainView)
            make.height.equalTo(44)
            make.top.equalTo(verificationCodeTextField.snp.bottom).inset(1)
            make.left.equalTo(mainView)
        })
        verificationCodeTextField.delegate = self
    }
    
    var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "To complete your phone number verification, please enter the 6-digit activation code."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var verificationCodeTextField: UITextField = {
        var textView = UITextField()
        textView.placeholder = "Verification Code"
        textView.keyboardType = .asciiCapableNumberPad
        textView.font = UIFont.systemFont(ofSize: 27)
        textView.textColor = UIColor(rgb: 0xC7C7CC)
        textView.textAlignment = .center
        textView.backgroundColor = .white
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor(rgb: 0xdbdbdf).cgColor
        return textView
    }()
    
    var verifyCodeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Verify Code", for: .normal)
        button.setTitleColor(UIColor(rgb: 0x007AFF), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.contentHorizontalAlignment = .center
        button.layer.borderWidth = 0.5
        button.backgroundColor = .white
        button.layer.borderColor = UIColor(rgb: 0xdbdbdf).cgColor
        button.addTarget(self, action: #selector(tappedButton), for: .touchDown)
        return button
    }()
    
    @objc func tappedButton() {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: recievedVerificationCode!,
            verificationCode: verificationCodeTextField.text!)
        signIn(with: credential)
    }
    
    func signIn(with credential: PhoneAuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self](authResult, error) in
            if let error = error {
                print("authentication error \(error.localizedDescription)")
            }
            
            //check if user exists -> Log him in
            
            //otherwise send to createUserOrRetrieve User
            let controller = CreateUserViewController()
            self?.verificationDelegate = controller
            self?.verificationDelegate?.sucess(phoneNumber: (self?.title)!)
            self?.navigationController?.pushViewController(controller, animated: true)

        }
    }
}

extension VerificationCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 6
    }
}

extension VerificationCodeViewController: LoginViewControllerDelegate {
    func pressedNext(verificationCode: String?, phoneNumber: String) {
        recievedVerificationCode = verificationCode
        title = phoneNumber
    }
}


