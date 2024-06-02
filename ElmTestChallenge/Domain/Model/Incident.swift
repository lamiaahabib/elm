//
//  Incident.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/2/24.
//

import Foundation

public struct IncidentsResponse: Decodable {
    public let incidents: [Incident]
}

public struct Incident: Identifiable, Decodable {
    public let id: String
    public let description: String
    public let latitude: Double
    public let longitude: Double
    public let status: Int
    public let priority: Int?
    public let typeId: Int
    public let issuerId: String
    public let assigneeId: String?
    public let createdAt: String
    public let updatedAt: String
    public let medias: [Media]?
}

public struct Media: Identifiable, Decodable {
    public let id: String
    public let mimeType: String
    public let url: String
    public let type: Int
    public let incidentId: String
}
