//
//  VC.swift
//  WhatsAppClone
//
//  Created by Peter Shaburov on 6/1/21.
//

import Foundation
import UIKit

class VC: UIViewController {
    
    var navigationBarHeight: CGFloat {
        get {
            return (navigationController?.navigationBar.frame.height)!
        }
    }
    
    override func viewDidLoad() {
        navigationController?.navigationBar.tintColor = UIColor(rgb: 0xA6A6AA)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
