//
//  LaunchDetails.swift
//  SpaceX
//
//  Created by Bruno Guedes on 18/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import Foundation

struct LaunchDetails {
    let flightNumber: Int
    let missionName: String
    let date: Date
    let launchSuccess: Bool
    let details: String
    let rocketId: String
}

extension LaunchDetails: Decodable {
    enum CodingKeys: String, CodingKey {
        case flightNumber = "flight_number"
        case missionName = "mission_name"
        case date = "launch_date_utc"
        case launchSuccess = "launch_success"
        case details = "details"
        case rocket = "rocket"
        case rocketId = "rocket_id"
    }
    
    enum RocketCodingKeys: String, CodingKey {
        case rocketId = "rocket_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.flightNumber = try container.decode(Int.self, forKey: .flightNumber)
        self.missionName = try container.decode(String.self, forKey: .missionName)
        let dateString = try container.decode(String.self, forKey: .date)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        if let date = formatter.date(from: dateString) {
            self.date = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Invalid date format")
        }
        self.launchSuccess = try container.decode(Bool.self, forKey: .launchSuccess)
        self.details = try container.decode(String.self, forKey: .details)
        let rocketDecoder = try container.superDecoder(forKey: .rocket)
        let rocketContainer = try rocketDecoder.container(keyedBy: RocketCodingKeys.self)
        self.rocketId = try rocketContainer.decode(String.self, forKey: .rocketId)
    }
}
