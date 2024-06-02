//
//  VerifyOTPUseCase.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/1/24.
//

import Foundation
import Combine

public class VerifyOTPUseCase {
    private let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    public func execute(email: String, otp: String) -> AnyPublisher<VerifyOTPResponse, Error> {
        return networkService.verifyOTP(email: email, otp: otp)
    }
}
