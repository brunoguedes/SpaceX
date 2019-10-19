//
//  FlowCoordinator.swift
//  SpaceX
//
//  Created by Bruno Guedes on 18/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import UIKit

struct FlowCoordinator {
    
    let navigationController: UINavigationController
    
    init() {
        let viewController = UIViewController()
        navigationController = UINavigationController(rootViewController: viewController)
    }
}
