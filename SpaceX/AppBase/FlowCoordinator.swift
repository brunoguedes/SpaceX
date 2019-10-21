//
//  FlowCoordinator.swift
//  SpaceX
//
//  Created by Bruno Guedes on 18/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import UIKit

class FlowCoordinator {
    
    let navigationController = UINavigationController()
    
    func createNavigation() -> UINavigationController {
        let launchesViewController = LaunchesViewController { [weak self] (flightNumber) in
            self?.navigateToMissionDetails(for: flightNumber)
        }
        navigationController.viewControllers = [launchesViewController]
        return navigationController
    }
    
    func navigateToMissionDetails(for flightNumber: Int) {
        let missionDetailsViewController = MissionDetailsViewController(flightNumber: flightNumber) { [weak self] (url) in
            self?.navigateToWebPage(with: url)
        }
        navigationController.pushViewController(missionDetailsViewController, animated: true)
    }
    
    func navigateToWebPage(with url: URL) {
        let webViewController = WebPageViewController(url: url)
        navigationController.pushViewController(webViewController, animated: true)
    }
}
