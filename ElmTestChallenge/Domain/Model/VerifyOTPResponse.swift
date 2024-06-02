//
//  VerifyOTPResponse.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/1/24.
//


import Foundation

public struct VerifyOTPResponse: Decodable {
    let token: String
    let roles: [Int]
}
