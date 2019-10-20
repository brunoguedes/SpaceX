//
//  LaunchViewModel.swift
//  SpaceX
//
//  Created by Bruno Guedes on 20/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import Foundation

struct LaunchViewModel {
    let dateFormatter = DateFormatter()
    
    var name: String {
        return launch.missionName
    }
    
    var date: String {
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: launch.date)
    }
    
    var status: String {
        switch launch.launchSuccess {
        case .success:
            return "Succeeded"
        case .fail:
            return "Failed"
        case .scheduled:
            return "Scheduled"
        }
    }
    
    let launch: Launch
    
    init(launch: Launch) {
        self.launch = launch
    }
}
