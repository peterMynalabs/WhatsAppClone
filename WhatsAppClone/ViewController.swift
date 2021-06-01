//
//  ViewController.swift
//  WhatsAppClone
//
//  Created by Peter Shaburov on 6/1/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if !UserDefaults.isFirstLaunch() { //remember to Undo
            navigationController?.pushViewController(LoginViewController(), animated: false)
        } else {
            print("yp")
        }
    }
}

