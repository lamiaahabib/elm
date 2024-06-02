//
//  NetworkServiceProtocol.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/1/24.
//
import Foundation
import Combine

public protocol NetworkServiceProtocol {
    func login(email: String) -> AnyPublisher<String, Error>
    func verifyOTP(email: String, otp: String) -> AnyPublisher<VerifyOTPResponse, Error>
    func fetchIncidents(token: String) -> AnyPublisher<[Incident], Error>
    func fetchDashboardData(token: String) -> AnyPublisher<DashboardResponse, Error>
    func changeIncidentStatus(token: String, incidentId: String, newStatus: IncidentStatus) -> AnyPublisher<Incident, Error>
    func postNewIncident(token: String, newIncident: NewIncident) -> AnyPublisher<[Incident], Error>

}

