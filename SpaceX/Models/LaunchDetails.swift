//
//  LaunchDetails.swift
//  SpaceX
//
//  Created by Bruno Guedes on 18/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import Foundation

class LaunchDetails: Launch {
    let launchSiteName: String
    let rocketId: String
    
    init(
        flightNumber: Int,
        missionName: String,
        date: Date,
        launchSuccess: LaunchStatus,
        launchSiteName: String,
        rocketId: String
    ) {
        self.launchSiteName = launchSiteName
        self.rocketId = rocketId
        super.init(flightNumber: flightNumber, missionName: missionName, date: date, launchSuccess: launchSuccess)
    }

    enum LaunchDetailsCodingKeys: String, CodingKey {
        case launchSite = "launch_site"
        case rocket = "rocket"
    }
    
    enum RocketCodingKeys: String, CodingKey {
        case rocketId = "rocket_id"
    }
    
    enum LaunchSiteKeys: String, CodingKey {
        case launchSiteName = "site_name_long"
    }
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: LaunchDetailsCodingKeys.self)
            let launchSiteDecoder = try container.superDecoder(forKey: .launchSite)
            let launchSiteContainer = try launchSiteDecoder.container(keyedBy: LaunchSiteKeys.self)
            self.launchSiteName = try launchSiteContainer.decode(String.self, forKey: .launchSiteName)
            let rocketDecoder = try container.superDecoder(forKey: .rocket)
            let rocketContainer = try rocketDecoder.container(keyedBy: RocketCodingKeys.self)
            self.rocketId = try rocketContainer.decode(String.self, forKey: .rocketId)
            try super.init(from: decoder)
        } catch let error {
            throw error
        }
    }
}
