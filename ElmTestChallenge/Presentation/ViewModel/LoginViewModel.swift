//
//  LoginViewModel.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/1/24.
//

import Foundation
import Combine

public class LoginViewModel: ObservableObject {
    @Published public var email: String = ""
    @Published public var loginSuccess: Bool = false
    @Published public var loginFailed: Bool = false
    @Published public var errorMessage: String?
    @Published public var isLoading: Bool = false
    @Published public var otpRequired: Bool = false
    
    private let loginUseCase: LoginUseCase
    private var cancellables = Set<AnyCancellable>()
    
    public init(loginUseCase: LoginUseCase = LoginUseCase()) {
        self.loginUseCase = loginUseCase
    }
    
    public func login() {
        guard email.isValidEmail else {
            self.loginFailed = true
            self.loginSuccess = false
            self.errorMessage = "Invalid email format"
            return
        }
        
        isLoading = true
        loginUseCase.execute(email: email)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.loginFailed = true
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { response in
                if response == "OK" {
                    self.loginSuccess = true
                    self.loginFailed = false
                    self.otpRequired = true // Indicate that OTP is required
                } else {
                    self.loginFailed = true
                    self.errorMessage = "Invalid response"
                }
            })
            .store(in: &self.cancellables)
    }
}
