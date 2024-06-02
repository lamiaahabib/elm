//
//  NewIncident.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/2/24.
//

public struct NewIncident: Codable {
    public let description: String
    public let latitude: Double
    public let longitude: Double
    public let typeId: Int
    public let priority: Int
}
