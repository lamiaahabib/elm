//
//  LoginResponse.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/1/24.
//

import Foundation

struct LoginResponse: Decodable {
    let success: Bool
    let token: String?
    let message: String?
}
