//
//  LaunchesViewModel.swift
//  SpaceX
//
//  Created by Bruno Guedes on 20/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct SectionOfLaunches {
    var header: String
    var items: [Item]
}
extension SectionOfLaunches: SectionModelType {
    typealias Item = LaunchViewModel
    
    init(original: SectionOfLaunches, items: [Item]) {
        self = original
        self.items = items
    }
}

struct LaunchesViewModel {
    
    enum SortBy {
        case missionName
        case date
    }
    
    public let launchesBasicInfoBySection: Observable<[SectionOfLaunches]>
    
    init(launches: Observable<Launches>, onlySuccessful: Observable<Bool>, sortedBy: Observable<SortBy>) {
        self.launchesBasicInfoBySection = Observable.combineLatest(launches, onlySuccessful, sortedBy).map { (launches, filterOnlySuccessful, sortedBy) -> [SectionOfLaunches] in
            return launches
                .filter({ !filterOnlySuccessful || $0.launchSuccess == .success })
                .sorted(by: { (launch1, launch2) -> Bool in
                    switch sortedBy {
                    case .missionName:
                        return launch1.missionName < launch2.missionName
                    case .date:
                        return launch1.date < launch2.date
                    }
                })
                .reduce([SectionOfLaunches]()) { (result, launch) -> [SectionOfLaunches] in
                    var updatedResult = result
                    var sectionName = ""
                    switch sortedBy {
                    case .date:
                        sectionName = "\(Calendar.current.component(.year, from: launch.date))"
                    case .missionName:
                        sectionName = String(launch.missionName.prefix(1))
                    }
                    var addNewSection = true
                    for index in 0..<result.count {
                        if sectionName == result[index].header {
                            let sectionOfLaunches = result[index]
                            let items = sectionOfLaunches.items + [LaunchViewModel(launch: launch)]
                            let updatedSectionOfLaunches = SectionOfLaunches(original: sectionOfLaunches, items: items)
                            updatedResult[index] = updatedSectionOfLaunches
                            addNewSection = false
                            break
                        }
                    }
                    if addNewSection {
                        updatedResult.append(SectionOfLaunches(header: sectionName, items: [LaunchViewModel(launch: launch)]))
                    }
                    return updatedResult
            }
        }
    }
}
