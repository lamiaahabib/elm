//
//  FetchIncidentsUseCase.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/2/24.
//

import Foundation
import Combine

public class FetchIncidentsUseCase {
    private let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    public func execute(token: String) -> AnyPublisher<[Incident], Error> {
        return networkService.fetchIncidents(token: token)
    }
}
