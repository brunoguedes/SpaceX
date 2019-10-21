//
//  MissionDetailsViewModel.swift
//  SpaceX
//
//  Created by Bruno Guedes on 21/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import Foundation

struct MissionDetailsViewModel {
    
    var details: String {
        return """
        Mission Name: \(launchViewModel.name)\n
        Launch Date: \(launchViewModel.date)\n
        Launch Status: \(launchViewModel.status)\n
        Site Name: \(launchDetails.launchSiteName)\n
        Rocket Name: \(rocketDetails.rocketName)\n
        \(rocketDetails.details)\n
        """
    }
        
    var wikipediaURL: URL {
        return rocketDetails.wikipediaURL
    }
    
    let launchDetails: LaunchDetails
    let rocketDetails: RocketDetails
    let launchViewModel: LaunchViewModel
    
    init(launchDetails: LaunchDetails, rocketDetails: RocketDetails) {
        self.launchDetails = launchDetails
        self.rocketDetails = rocketDetails
        self.launchViewModel = LaunchViewModel(launch: launchDetails)
    }
}
