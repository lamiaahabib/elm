//
//  OTPViewModel.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/1/24.
//

import Foundation
import Combine

public class OTPViewModel: ObservableObject {
    @Published public var email: String = ""
    @Published public var otp: String = ""
    @Published public var verificationSuccess: Bool = false
    @Published public var verificationFailed: Bool = false
    @Published public var errorMessage: String?
    @Published public var isLoading: Bool = false
    @Published public var token: String?
    @Published public var roles: [Int] = []
    
    private let verifyOTPUseCase: VerifyOTPUseCase
    private var cancellables = Set<AnyCancellable>()
    
    public init(verifyOTPUseCase: VerifyOTPUseCase = VerifyOTPUseCase()) {
        self.verifyOTPUseCase = verifyOTPUseCase
    }
    
    public func verifyOTP() {
        guard otp.count == 4, otp.allSatisfy({ $0.isNumber }) else {
            self.verificationFailed = true
            self.errorMessage = "OTP must be exactly 4 digits."
            return
        }
        
        isLoading = true
        verifyOTPUseCase.execute(email: email, otp: otp)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.verificationFailed = true
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.token = response.token
                self.roles = response.roles
                self.verificationSuccess = true
                self.verificationFailed = false
                self.saveToken(response.token)
            })
            .store(in: &self.cancellables)
    }
    
    private func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "userToken")
    }
}
