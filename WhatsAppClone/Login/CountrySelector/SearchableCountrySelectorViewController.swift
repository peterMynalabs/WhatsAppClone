//
//  SearchAbleCountrySelectorView.swift
//  WhatsAppClone
//
//  Created by Peter Shaburov on 6/2/21.
//

import Foundation
import UIKit
import SnapKit

protocol SearchableCountrySelectorDelegate: class {
    func pressedCell(country: String)
}

class SearchableCountrySelectorViewController: UIViewController {
    
    var mainView = UIView()
    var listOfCountries: [String] = []
    weak var searchableCountrySelectorDelegate: SearchableCountrySelectorDelegate?
    
    override func loadView() {
        mainView.frame = UIScreen.main.bounds
        view = mainView
        mainView.backgroundColor = .white
        
        mainView.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) -> Void in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.size.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupKeyboardNotifications()
    }
    
    var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor =  UIColor(rgb: 0xF6F6F6)
        return tableView
    }()
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension SearchableCountrySelectorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.textLabel?.text =  listOfCountries[indexPath.row]
        cell.detailTextLabel!.text = "+" + Country().getCountryPhoneCode(from: listOfCountries[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchableCountrySelectorDelegate?.pressedCell(country: listOfCountries[indexPath.row])
    }
}
