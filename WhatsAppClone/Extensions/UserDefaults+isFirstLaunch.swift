//
//  UserDefaults+isFirstLaunch.swift
//  WhatsAppClone
//
//  Created by Peter Shaburov on 6/1/21.
//

import Foundation

extension UserDefaults {
    static func isFirstLaunch() -> Bool {
          let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
          let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
          if (isFirstLaunch) {
              UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
              UserDefaults.standard.synchronize()
          }
          return isFirstLaunch
      }
}
