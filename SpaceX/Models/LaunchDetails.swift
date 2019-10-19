//
//  LaunchDetails.swift
//  SpaceX
//
//  Created by Bruno Guedes on 18/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import Foundation

class LaunchDetails: Launch {
    let details: String
    let rocketId: String
    
    init(
        flightNumber: Int,
        missionName: String,
        date: Date,
        launchSuccess: LaunchStatus,
        details: String,
        rocketId: String
    ) {
        self.details = details
        self.rocketId = rocketId
        super.init(flightNumber: flightNumber, missionName: missionName, date: date, launchSuccess: launchSuccess)
    }

    enum LaunchDetailsCodingKeys: String, CodingKey {
        case details = "details"
        case rocket = "rocket"
        case rocketId = "rocket_id"
    }
    
    enum RocketCodingKeys: String, CodingKey {
        case rocketId = "rocket_id"
    }
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: LaunchDetailsCodingKeys.self)
            self.details = try container.decode(String.self, forKey: .details)
            let rocketDecoder = try container.superDecoder(forKey: .rocket)
            let rocketContainer = try rocketDecoder.container(keyedBy: RocketCodingKeys.self)
            self.rocketId = try rocketContainer.decode(String.self, forKey: .rocketId)
            try super.init(from: decoder)
        } catch let error {
            throw error
        }
    }
}
