//
//  DashboardViewModel.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/2/24.
//

import Foundation
import Combine


public class DashboardViewModel: ObservableObject {
    @Published public var incidentStats: [IncidentStat] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    public init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    public func fetchDashboardData(token: String) {
        isLoading = true
        errorMessage = nil
        
        networkService.fetchDashboardData(token: token)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.incidentStats = response.incidents
            })
            .store(in: &self.cancellables)
    }
}
