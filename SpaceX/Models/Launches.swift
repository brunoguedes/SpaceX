//
//  Launches.swift
//  SpaceX
//
//  Created by Bruno Guedes on 20/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import Foundation

typealias Launches = [Launch]

class Launch: Decodable {
    enum LaunchStatus {
        case success
        case fail
        case scheduled
    }
    
    let flightNumber: Int
    let missionName: String
    let date: Date
    let launchSuccess: LaunchStatus
    
    init(
        flightNumber: Int,
        missionName: String,
        date: Date,
        launchSuccess: LaunchStatus
    ) {
        self.flightNumber = flightNumber
        self.missionName = missionName
        self.date = date
        self.launchSuccess = launchSuccess
    }

    enum CodingKeys: String, CodingKey {
        case flightNumber = "flight_number"
        case missionName = "mission_name"
        case date = "launch_date_utc"
        case launchSuccess = "launch_success"
    }
    
    required init(from decoder: Decoder) throws {
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
        if let launchSuccess = try container.decode(Bool?.self, forKey: .launchSuccess) {
            self.launchSuccess = launchSuccess ? .success : .fail
        } else {
            self.launchSuccess = .scheduled
        }
    }
}
