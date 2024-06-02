//
//  NewIncidentViewModel.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/2/24.
//


import Foundation
import Combine

public class NewIncidentViewModel: ObservableObject {
    @Published public var description: String = ""
    @Published public var latitude: String = ""
    @Published public var longitude: String = ""
    @Published public var typeId: String = ""
    @Published public var priority: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var successMessage: String?
    
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    public init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    public func postNewIncident(token: String) {
        // Reset messages
        errorMessage = nil
        successMessage = nil
        
        guard !description.isEmpty, let lat = Double(latitude), let lon = Double(longitude), let typeId = Int(typeId), let priority = Int(priority) else {
            errorMessage = "All fields are required and must be valid"
            return
        }
        
        isLoading = true
        
        let newIncident = NewIncident(description: description, latitude: lat, longitude: lon, typeId: typeId, priority: priority)
        
        networkService.postNewIncident(token: token, newIncident: newIncident)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    self.successMessage = "Incident posted successfully!"
                }
            }, receiveValue: { response in
                // Handle response if needed
            })
            .store(in: &self.cancellables)
    }
}
