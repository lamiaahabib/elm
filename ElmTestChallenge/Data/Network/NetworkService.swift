//
//  NetworkService.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/1/24.
//


import Foundation
import Combine

public class NetworkService: NetworkServiceProtocol {
    
    public static let shared = NetworkService()
    
    // Make initializer public
    public init() {}
    
    public func login(email: String) -> AnyPublisher<String, Error> {
        guard let url = URL(string: API.loginURL) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .tryMap { data in
                guard let responseString = String(data: data, encoding: .utf8), responseString == "OK" else {
                    throw URLError(.badServerResponse)
                }
                return responseString
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func verifyOTP(email: String, otp: String) -> AnyPublisher<VerifyOTPResponse, Error> {
           guard let url = URL(string: API.verifyOTPURL) else {
               return Fail(error: URLError(.badURL))
                   .eraseToAnyPublisher()
           }
           
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           let body = ["email": email, "otp": otp]
           request.httpBody = try? JSONSerialization.data(withJSONObject: body)
           
           return URLSession.shared.dataTaskPublisher(for: request)
               .map { $0.data }
               .decode(type: VerifyOTPResponse.self, decoder: JSONDecoder())
               .receive(on: DispatchQueue.main)
               .eraseToAnyPublisher()
       }
    public func fetchIncidents(token: String) -> AnyPublisher<[Incident], Error> {
           guard let url = URL(string: API.incidentsURL) else {
               return Fail(error: URLError(.badURL))
                   .eraseToAnyPublisher()
           }
           
           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
           
           let decoder = JSONDecoder()
           decoder.keyDecodingStrategy = .convertFromSnakeCase
           decoder.dateDecodingStrategy = .iso8601
           
           return URLSession.shared.dataTaskPublisher(for: request)
               .map { $0.data }
               .decode(type: IncidentsResponse.self, decoder: decoder)
               .map { $0.incidents }
               .receive(on: DispatchQueue.main)
               .eraseToAnyPublisher()
       }
  
    public func fetchDashboardData(token: String) -> AnyPublisher<DashboardResponse, Error> {
           guard let url = URL(string: API.dashboardDataURL) else {
               return Fail(error: URLError(.badURL))
                   .eraseToAnyPublisher()
           }
           
           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
           
           return URLSession.shared.dataTaskPublisher(for: request)
               .map { $0.data }
               .decode(type: DashboardResponse.self, decoder: JSONDecoder())
               .receive(on: DispatchQueue.main)
               .eraseToAnyPublisher()
       }
    
    public func changeIncidentStatus(token: String, incidentId: String, newStatus: IncidentStatus) -> AnyPublisher<Incident, Error> {
           guard let url = URL(string: "\(API.incidentsURL)/change-status") else {
               return Fail(error: URLError(.badURL))
                   .eraseToAnyPublisher()
           }
           
           var request = URLRequest(url: url)
           request.httpMethod = "PUT"
           request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           let body: [String: Any] = ["incidentId": incidentId, "status": newStatus.rawValue]
           request.httpBody = try? JSONSerialization.data(withJSONObject: body)
           
           return URLSession.shared.dataTaskPublisher(for: request)
               .map { $0.data }
               .decode(type: Incident.self, decoder: JSONDecoder())
               .receive(on: DispatchQueue.main)
               .eraseToAnyPublisher()
       }
    
    public func postNewIncident(token: String, newIncident: NewIncident) ->  AnyPublisher<[Incident], Error> {
        guard let url = URL(string: API.incidentsURL) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONEncoder().encode(newIncident)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: IncidentsResponse.self, decoder: decoder)
            .map { $0.incidents }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
