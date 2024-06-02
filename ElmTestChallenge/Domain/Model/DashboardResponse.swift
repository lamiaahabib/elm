//
//  DashboardResponse.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/2/24.
//

import Foundation

public struct DashboardResponse: Decodable {
    public let incidents: [IncidentStat]
}

public struct IncidentStat: Identifiable, Decodable {
    public var id: UUID { UUID() } // Generate a unique ID for Identifiable conformance
    public let status: IncidentStatus
    public let count: Int

    enum CodingKeys: String, CodingKey {
        case status
        case _count
    }

    enum CountKeys: String, CodingKey {
        case status
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(IncidentStatus.self, forKey: .status)
        
        let countContainer = try container.nestedContainer(keyedBy: CountKeys.self, forKey: ._count)
        count = try countContainer.decode(Int.self, forKey: .status)
    }
}
