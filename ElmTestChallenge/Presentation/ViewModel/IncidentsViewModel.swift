//
//  IncidentsViewModel.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/2/24.
//

import Foundation
import Combine

public class IncidentsViewModel: ObservableObject {
    @Published public var incidents: [Incident] = []
    @Published public var filteredIncidents: [Incident] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var selectedStatus: IncidentStatus? = nil
    @Published public var startDate: Date? = nil
    @Published public var endDate: Date? = nil
    
    private let fetchIncidentsUseCase: FetchIncidentsUseCase
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    public init(fetchIncidentsUseCase: FetchIncidentsUseCase = FetchIncidentsUseCase(), networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.fetchIncidentsUseCase = fetchIncidentsUseCase
        self.networkService = networkService
    }
    
    public func fetchIncidents(token: String) {
        isLoading = true
        errorMessage = nil
        
        fetchIncidentsUseCase.execute(token: token)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { incidents in
                self.incidents = incidents
                self.applyFilters()
            })
            .store(in: &self.cancellables)
    }
    
    public func applyFilters() {
        filteredIncidents = incidents.filter { incident in
            var matchesStatus = true
            var matchesDateRange = true
            
            if let selectedStatus = selectedStatus {
                matchesStatus = incident.status == selectedStatus.rawValue
            }
            
            if let startDate = startDate, let endDate = endDate {
                let incidentDate = ISO8601DateFormatter().date(from: incident.createdAt) ?? Date()
                matchesDateRange = (incidentDate >= startDate) && (incidentDate <= endDate)
            }
            
            return matchesStatus && matchesDateRange
        }
    }
    
    public func setFilter(status: IncidentStatus?) {
        selectedStatus = status
        applyFilters()
    }
    
    public func setFilter(startDate: Date?, endDate: Date?) {
        self.startDate = startDate
        self.endDate = endDate
        applyFilters()
    }
    
    public func resetFilters() {
        selectedStatus = nil
        startDate = nil
        endDate = nil
        applyFilters()
    }

    public func changeIncidentStatus(token: String, incidentId: String, newStatus: IncidentStatus) {
        isLoading = true
        errorMessage = nil
        
        networkService.changeIncidentStatus(token: token, incidentId: incidentId, newStatus: newStatus)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { updatedIncident in
                if let index = self.incidents.firstIndex(where: { $0.id == updatedIncident.id }) {
                    self.incidents[index] = updatedIncident
                    self.applyFilters()
                }
            })
            .store(in: &self.cancellables)
    }
}
