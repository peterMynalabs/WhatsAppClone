//
//  AppDelegate.swift
//  WhatsAppClone
//
//  Created by Peter Shaburov on 6/1/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        self.window = UIWindow(frame: UIScreen.main.bounds)
        var controller: UIViewController?
        if !UserDefaults.isFirstLaunch() { //remember to Undo
            controller = LoginViewController()
        } else {
            controller = ViewController()
        }
        let mainNavigationController = UINavigationController()
        
        mainNavigationController.viewControllers = [controller!]
        
        window?.rootViewController = mainNavigationController
        window?.makeKeyAndVisible()
        return true
    }

}

