//
//  RocketDetails.swift
//  SpaceX
//
//  Created by Bruno Guedes on 18/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import Foundation

struct RocketDetails {
    let rocketName: String
    let details: String
    let wikipediaURL: URL
}

extension RocketDetails: Decodable {
    enum CodingKeys: String, CodingKey {
        case rocketName = "rocket_name"
        case details = "description"
        case wikipediaURL = "wikipedia"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rocketName = try container.decode(String.self, forKey: .rocketName)
        self.details = try container.decode(String.self, forKey: .details)
        self.wikipediaURL = try container.decode(URL.self, forKey: .wikipediaURL)
    }
}
