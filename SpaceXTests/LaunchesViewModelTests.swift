//
//  LaunchesViewModelTests.swift
//  SpaceXTests
//
//  Created by Bruno Guedes on 20/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxBlocking
@testable import SpaceX

class LaunchesViewModelTests: XCTestCase {
    
    let disposeBag = DisposeBag()
    let dateFormatter = ISO8601DateFormatter()
    
    var launches: Launches = [Launch]()
    
    override func setUp() {
        dateFormatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        launches = [
            Launch(
                flightNumber: 1,
                missionName: "Za Mission",
                date: dateFormatter.date(from: "2016-03-25T22:30:00.000Z")!,
                launchSuccess: .fail
            ),
            Launch(
                flightNumber: 1,
                missionName: "Zb Mission",
                date: dateFormatter.date(from: "2016-03-24T22:30:00.000Z")!,
                launchSuccess: .fail
            ),
            Launch(
                flightNumber: 1,
                missionName: "Aa Mission",
                date: dateFormatter.date(from: "2018-06-30T09:42:00.000Z")!,
                launchSuccess: .success
            ),
            Launch(
                flightNumber: 1,
                missionName: "Ab Mission",
                date: dateFormatter.date(from: "2018-06-29T09:42:00.000Z")!,
                launchSuccess: .success
            ),
            Launch(
                flightNumber: 1,
                missionName: "Ga Mission",
                date: dateFormatter.date(from: "2010-11-02T00:00:00.000Z")!,
                launchSuccess: .success
            ),
            Launch(
                flightNumber: 1,
                missionName: "Gb Mission",
                date: dateFormatter.date(from: "2010-11-01T00:00:00.000Z")!,
                launchSuccess: .success
            ),
            Launch(
                flightNumber: 1,
                missionName: "Ca Mission",
                date: dateFormatter.date(from: "2020-10-02T00:00:00.000Z")!,
                launchSuccess: .scheduled
            ),
            Launch(
                flightNumber: 1,
                missionName: "Cb Mission",
                date: dateFormatter.date(from: "2020-10-01T00:00:00.000Z")!,
                launchSuccess: .scheduled
            )
        ]
    }

    func testLaunchesSortedByName() {
        let viewModel = LaunchesViewModel(
            launches: Observable.from(optional: launches),
            onlySuccessful: Observable.from(optional: false),
            sortedBy: Observable.from(optional: .missionName)
        )
        viewModel.launchesBasicInfoBySection.subscribe(onNext: { (sections) in
            XCTAssertEqual(sections.count, 4)
            
            var section = sections[0]
            XCTAssertEqual(section.header, "A")
            XCTAssertEqual(section.items.count, 2)
            XCTAssertEqual(section.items[0].name, "Aa Mission")
            XCTAssertEqual(section.items[0].date, "30 Jun 2018")
            XCTAssertEqual(section.items[0].status, "Succeeded")
            XCTAssertEqual(section.items[1].name, "Ab Mission")
            XCTAssertEqual(section.items[1].date, "29 Jun 2018")
            XCTAssertEqual(section.items[1].status, "Succeeded")
            
            section = sections[1]
            XCTAssertEqual(section.header, "C")
            XCTAssertEqual(section.items.count, 2)
            XCTAssertEqual(section.items[0].name, "Ca Mission")
            XCTAssertEqual(section.items[0].date, "02 Oct 2020")
            XCTAssertEqual(section.items[0].status, "Scheduled")
            XCTAssertEqual(section.items[1].name, "Cb Mission")
            XCTAssertEqual(section.items[1].date, "01 Oct 2020")
            XCTAssertEqual(section.items[1].status, "Scheduled")

            section = sections[2]
            XCTAssertEqual(section.header, "G")
            XCTAssertEqual(section.items.count, 2)
            XCTAssertEqual(section.items[0].name, "Ga Mission")
            XCTAssertEqual(section.items[0].date, "02 Nov 2010")
            XCTAssertEqual(section.items[0].status, "Succeeded")
            XCTAssertEqual(section.items[1].name, "Gb Mission")
            XCTAssertEqual(section.items[1].date, "01 Nov 2010")
            XCTAssertEqual(section.items[1].status, "Succeeded")

            section = sections[3]
            XCTAssertEqual(section.header, "Z")
            XCTAssertEqual(section.items.count, 2)
            XCTAssertEqual(section.items[0].name, "Za Mission")
            XCTAssertEqual(section.items[0].date, "26 Mar 2016")
            XCTAssertEqual(section.items[0].status, "Failed")
            XCTAssertEqual(section.items[1].name, "Zb Mission")
            XCTAssertEqual(section.items[1].date, "25 Mar 2016")
            XCTAssertEqual(section.items[1].status, "Failed")
            }).disposed(by: disposeBag)
    }
    
    func testLaunchesSortedByDate() {
        let viewModel = LaunchesViewModel(
            launches: Observable.from(optional: launches),
            onlySuccessful: Observable.from(optional: false),
            sortedBy: Observable.from(optional: .date)
        )
        viewModel.launchesBasicInfoBySection.subscribe(onNext: { (sections) in
            XCTAssertEqual(sections.count, 4)
            
            var section = sections[0]
            XCTAssertEqual(section.header, "2010")
            XCTAssertEqual(section.items.count, 2)
            XCTAssertEqual(section.items[0].name, "Gb Mission")
            XCTAssertEqual(section.items[0].date, "01 Nov 2010")
            XCTAssertEqual(section.items[0].status, "Succeeded")
            XCTAssertEqual(section.items[1].name, "Ga Mission")
            XCTAssertEqual(section.items[1].date, "02 Nov 2010")
            XCTAssertEqual(section.items[1].status, "Succeeded")
            
            section = sections[1]
            XCTAssertEqual(section.header, "2016")
            XCTAssertEqual(section.items.count, 2)
            XCTAssertEqual(section.items[0].name, "Zb Mission")
            XCTAssertEqual(section.items[0].date, "25 Mar 2016")
            XCTAssertEqual(section.items[0].status, "Failed")
            XCTAssertEqual(section.items[1].name, "Za Mission")
            XCTAssertEqual(section.items[1].date, "26 Mar 2016")
            XCTAssertEqual(section.items[1].status, "Failed")
            
            section = sections[2]
            XCTAssertEqual(section.header, "2018")
            XCTAssertEqual(section.items.count, 2)
            XCTAssertEqual(section.items[0].name, "Ab Mission")
            XCTAssertEqual(section.items[0].date, "29 Jun 2018")
            XCTAssertEqual(section.items[0].status, "Succeeded")
            XCTAssertEqual(section.items[1].name, "Aa Mission")
            XCTAssertEqual(section.items[1].date, "30 Jun 2018")
            XCTAssertEqual(section.items[1].status, "Succeeded")
            
            section = sections[3]
            XCTAssertEqual(section.header, "2020")
            XCTAssertEqual(section.items.count, 2)
            XCTAssertEqual(section.items[0].name, "Cb Mission")
            XCTAssertEqual(section.items[0].date, "01 Oct 2020")
            XCTAssertEqual(section.items[0].status, "Scheduled")
            XCTAssertEqual(section.items[1].name, "Ca Mission")
            XCTAssertEqual(section.items[1].date, "02 Oct 2020")
            XCTAssertEqual(section.items[1].status, "Scheduled")
            }).disposed(by: disposeBag)
    }
    
    func testSuccessfulLaunchesSortedByName() {

        let viewModel = LaunchesViewModel(
            launches: Observable.from(optional: launches),
            onlySuccessful: Observable.from(optional: true),
            sortedBy: Observable.from(optional: .missionName)
        )
        viewModel.launchesBasicInfoBySection.subscribe(onNext: { (sections) in
            XCTAssertEqual(sections.count, 2)
            
            var section = sections[0]
            XCTAssertEqual(section.header, "A")
            XCTAssertEqual(section.items.count, 2)
            XCTAssertEqual(section.items[0].name, "Aa Mission")
            XCTAssertEqual(section.items[0].date, "30 Jun 2018")
            XCTAssertEqual(section.items[0].status, "Succeeded")
            XCTAssertEqual(section.items[1].name, "Ab Mission")
            XCTAssertEqual(section.items[1].date, "29 Jun 2018")
            XCTAssertEqual(section.items[1].status, "Succeeded")

            section = sections[1]
            XCTAssertEqual(section.header, "G")
            XCTAssertEqual(section.items.count, 2)
            XCTAssertEqual(section.items[0].name, "Ga Mission")
            XCTAssertEqual(section.items[0].date, "02 Nov 2010")
            XCTAssertEqual(section.items[0].status, "Succeeded")
            XCTAssertEqual(section.items[1].name, "Gb Mission")
            XCTAssertEqual(section.items[1].date, "01 Nov 2010")
            XCTAssertEqual(section.items[1].status, "Succeeded")
            }).disposed(by: disposeBag)
    }
    
    func testSuccessfulLaunchesSortedByDate() {

        let viewModel = LaunchesViewModel(
            launches: Observable.from(optional: launches),
            onlySuccessful: Observable.from(optional: true),
            sortedBy: Observable.from(optional: .date)
        )
        viewModel.launchesBasicInfoBySection.subscribe(onNext: { (sections) in
            XCTAssertEqual(sections.count, 2)
            
            var section = sections[0]
            XCTAssertEqual(section.header, "2010")
            XCTAssertEqual(section.items.count, 2)
            XCTAssertEqual(section.items[0].name, "Gb Mission")
            XCTAssertEqual(section.items[0].date, "01 Nov 2010")
            XCTAssertEqual(section.items[0].status, "Succeeded")
            XCTAssertEqual(section.items[1].name, "Ga Mission")
            XCTAssertEqual(section.items[1].date, "02 Nov 2010")
            XCTAssertEqual(section.items[1].status, "Succeeded")
            
            section = sections[1]
            XCTAssertEqual(section.header, "2018")
            XCTAssertEqual(section.items.count, 2)
            XCTAssertEqual(section.items[0].name, "Ab Mission")
            XCTAssertEqual(section.items[0].date, "29 Jun 2018")
            XCTAssertEqual(section.items[0].status, "Succeeded")
            XCTAssertEqual(section.items[1].name, "Aa Mission")
            XCTAssertEqual(section.items[1].date, "30 Jun 2018")
            XCTAssertEqual(section.items[1].status, "Succeeded")
            }).disposed(by: disposeBag)
    }
    
}
