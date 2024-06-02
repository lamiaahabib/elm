//
//  IncidentDetailViewModel.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/2/24.
//

import Foundation
import Combine
import MapKit

public class IncidentDetailViewModel: ObservableObject {
    @Published public var incident: Incident
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var successMessage: String?
    
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    public init(incident: Incident, networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.incident = incident
        self.networkService = networkService
    }
    
    public func changeIncidentStatus(token: String, newStatus: IncidentStatus) {
            isLoading = true
            errorMessage = nil
            successMessage = nil
            
            networkService.changeIncidentStatus(token: token, incidentId: incident.id, newStatus: newStatus)
                .sink(receiveCompletion: { completion in
                    self.isLoading = false
                    switch completion {
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    case .finished:
                        self.successMessage = "Status changed successfully!"
                    }
                }, receiveValue: { updatedIncident in
                    self.incident = updatedIncident
                })
                .store(in: &self.cancellables)
        }
}
