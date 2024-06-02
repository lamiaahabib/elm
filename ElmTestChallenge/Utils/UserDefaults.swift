//
//  UserDefaults.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/2/24.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let userToken = "userToken"
    }
    
    var userToken: String? {
        get {
            return string(forKey: Keys.userToken)
        }
        set {
            set(newValue, forKey: Keys.userToken)
        }
    }
}
