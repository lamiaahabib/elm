//
//  IncidentStatus.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/2/24.
//

import Foundation

public enum IncidentStatus: Int, CaseIterable, Decodable, Identifiable {
    case submitted = 0
    case inProgress = 1
    case completed = 2
    case rejected = 3
    
    public var id: Int { rawValue }
    
    var description: String {
        switch self {
        case .submitted:
            return "Submitted"
        case .inProgress:
            return "In Progress"
        case .completed:
            return "Completed"
        case .rejected:
            return "Rejected"
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Int.self)
        if let status = IncidentStatus(rawValue: rawValue) {
            self = status
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid status value")
        }
    }
}
