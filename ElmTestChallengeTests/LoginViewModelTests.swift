//
//  LoginViewModelTests.swift
//  ElmTestChallengeTests
//
//  Created by lamiaa on 6/1/24.
//

import UIKit
import XCTest
import Foundation
import Combine
@testable import ElmTestChallenge
class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    var mockNetworkService: MockNetworkService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        let loginUseCase = LoginUseCase(networkService: mockNetworkService)
        viewModel = LoginViewModel(loginUseCase: loginUseCase)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testLoginSuccess() {
        let expectation = XCTestExpectation(description: "Login successful")
        
        viewModel.$loginSuccess
            .dropFirst()
            .sink { loginSuccess in
                XCTAssertTrue(loginSuccess)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.email = "test@example.com"
        viewModel.login()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoginFailure() {
        mockNetworkService.shouldReturnError = true
        let expectation = XCTestExpectation(description: "Login failed")
        
        viewModel.$loginFailed
            .dropFirst()
            .sink { loginFailed in
                XCTAssertTrue(loginFailed)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.email = "test@example.com"
        viewModel.login()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testInvalidEmailFormat() {
        let expectation = XCTestExpectation(description: "Invalid email format")
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "Invalid email format")
                XCTAssertTrue(self.viewModel.loginFailed)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.email = "invalid-email"
        viewModel.login()
        
        wait(for: [expectation], timeout: 1.0)
    }
}
