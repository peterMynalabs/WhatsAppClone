import Foundation
import UIKit
import SnapKit

class LoginViewController: VC {
    var mainView = UIView()
    var isNextButtonActivated = false
    var isPhoneNumberPresent = false
    var isCountryCodePresent = true
    
    override func loadView() {
        mainView.frame = UIScreen.main.bounds
        view = mainView
        mainView.backgroundColor = .white
        title = "Phone Number"
        setupNavigationBar()
        mainView.addSubview(mainTitleLabel)
        mainView.addSubview(countryButton)
        mainView.addSubview(countryLabel)
        mainView.addSubview(countryNumberTextView)
        mainView.addSubview(phoneNumberTextView)
        mainTitleLabel.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(40)
            make.top.equalTo(mainView).offset(107)
            make.centerX.equalToSuperview()
        })
        
        countryButton.snp.makeConstraints({ (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(45)
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(19)
            make.left.equalTo(0)
        })
        countryLabel.snp.makeConstraints({ (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(19)
            make.left.equalTo(15)
        })
        countryNumberTextView.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(86)
            make.height.equalTo(44)
            make.top.equalTo(countryButton.snp.bottom).inset(1)
            make.left.equalTo(0)
        })
        phoneNumberTextView.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(mainView)
            make.height.equalTo(44)
            make.top.equalTo(countryButton.snp.bottom).inset(1)
            make.left.equalTo(countryNumberTextView.snp.right).inset(1)
        })
        phoneNumberTextView.delegate = self
        countryNumberTextView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        countryButton.backgroundColor = .white
    }
    
    var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please confirm your country code and enter your phone number"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    
    var countryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage( UIImage(systemName: "chevron.right")?.withTintColor(UIColor(rgb: 0x3C3C43), renderingMode: .alwaysOriginal), for: .normal)
        button.contentHorizontalAlignment = .right
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 15)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(rgb: 0xdbdbdf).cgColor
        button.addTarget(self, action: #selector(countryTapped), for: .touchDown)
        return button
    }()
    
    var countryLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = Locale.currentCountryName()
        label.textColor = UIColor(rgb: 0x007AFF)
        label.textAlignment = .left
        return label
    }()
    
    var countryNumberTextView: UITextView = {
        var textView = UITextView()
        textView.text =  "+" + getCountryPhoneCode(Locale.currentCountryCode()!)
        textView.font = UIFont.systemFont(ofSize: 27)
        textView.textColor = .black
        textView.keyboardType = .asciiCapableNumberPad
        textView.textAlignment = .center
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor(rgb: 0xdbdbdf).cgColor
        return textView
    }()
    
    var phoneNumberTextView: UITextView = {
        var textView = UITextView()
        textView.text = "phone number"
        textView.keyboardType = .asciiCapableNumberPad
        textView.font = UIFont.systemFont(ofSize: 27)
        textView.textColor = UIColor(rgb: 0xC7C7CC)
        textView.textAlignment = .left
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor(rgb: 0xdbdbdf).cgColor
        return textView
    }()
    
    
    func setupNavigationBar() {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(clickedNext))
        button.tintColor = UIColor(rgb: 0xD1D1D6)
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], for: UIControl.State.normal)
        navigationItem.rightBarButtonItem = button
        navigationItem.leftBarButtonItem = UIBarButtonItem()
    }
    
    @objc
    func clickedNext() {
        if isNextButtonActivated {
            print("oh yeah")
        }
    }
    
    @objc
    func countryTapped() {
        countryButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    func validateNextButton(with sucess: Bool) {
        if sucess {
            navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0x007AFF)
        } else {
            navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0xD1D1D6)
        }
    }
    
    func checkFlags() {
        if isCountryCodePresent && isPhoneNumberPresent {
            isNextButtonActivated = true
            validateNextButton(with: true)
        } else {
            isNextButtonActivated = false
            validateNextButton(with: false)
        }
    }
    
    func updateCountryButton(with country: String) {
        if country == "error" {
            countryLabel.text = "Invalid country code"
            isCountryCodePresent = false
        } else {
            let countryName = Locale.getCountryName(from: country)
            countryLabel.text = countryName
            isCountryCodePresent = true
            checkFlags()
        }
    }
    
}

extension LoginViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == phoneNumberTextView {
            textView.text = ""
            title = "Phone Number"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        let currentText = textView.text!
        
        if textView == countryNumberTextView {
            
            var finishedText = currentText + text
            if isBackSpace == -92 {
                finishedText = String(finishedText.dropLast())
            }

            
            if currentText.count == 2 && isBackSpace == -92 {
                textView.text = ""
            }
            
            if currentText == ""  {
                finishedText = "+" + finishedText
                textView.text = "+"
            }
            
            if currentText.count > 3 {
                if isBackSpace != -92 {
                    return false
                }
            }
            
            if phoneNumberTextView.text != "phone number" && phoneNumberTextView.text != "" && finishedText != "+" {
                title =  finishedText + " " + phoneNumberTextView.text
            } else {
                title = "Phone Number"
            }
            
            
            var completeText = currentText + text
            if isBackSpace == -92 {
                completeText = String(completeText.dropLast())
            }
            let code = completeText.trimmingCharacters(in: CharacterSet(charactersIn: "+"))
            
          
            
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            updateCountryButton(with: getCountryPhoneCode(String(code)))
            
            return true
        } else {
            if currentText.count > 9 {
                if isBackSpace != -92 {
                    return false
                }
            }
            
            var finishedText = currentText + text
            if isBackSpace == -92 {
                finishedText = String(finishedText.dropLast())
            }
            
            if finishedText != "" {
                title = countryNumberTextView.text + " " + currentText + text
            } else {
                title = "Phone Number"
            }
            
            if currentText.count == 9 {
                isPhoneNumberPresent = true
                checkFlags()
            } else {
                isPhoneNumberPresent = false
                
            }
            
            return true
            
        }
    }
}
