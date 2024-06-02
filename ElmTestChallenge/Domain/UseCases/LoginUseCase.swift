//
//  LoginUseCase.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/1/24.
//



import Foundation
import Combine

public class LoginUseCase {
    private let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    public func execute(email: String) -> AnyPublisher<String, Error> {
        return networkService.login(email: email)
    }
}
