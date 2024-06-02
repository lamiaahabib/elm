//
//  StringExtensions.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/1/24.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        // Simple regex to check if the email is valid
        let emailFormat = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
}
