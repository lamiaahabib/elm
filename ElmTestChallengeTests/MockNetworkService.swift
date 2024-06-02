//
//  MockNetworkService.swift
//  ElmTestChallengeTests
//
//  Created by lamiaa on 6/1/24.
//
import XCTest
import Foundation
import Combine
@testable import ElmTestChallenge
class MockNetworkService: NetworkService {
    var shouldReturnError = false
    
    override func login(email: String) -> AnyPublisher<String, Error> {
        if shouldReturnError {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        } else {
            return Just("OK")
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
