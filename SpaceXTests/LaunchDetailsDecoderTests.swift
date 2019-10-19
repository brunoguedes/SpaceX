//
//  SpaceXTests.swift
//  SpaceXTests
//
//  Created by Bruno Guedes on 18/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import XCTest
@testable import SpaceX

class LaunchDetailsDecoderTests: XCTestCase {

    func testJsonDecoder() {
        let path = Bundle(for: type(of: self)).path(forResource: "LaunchDetails", ofType: "json")
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        guard let launchDetails = try? JSONDecoder().decode(LaunchDetails.self, from: jsonData!) else {
            fatalError()
        }
        XCTAssertEqual(launchDetails.flightNumber, 1)
        XCTAssertEqual(launchDetails.missionName, "FalconSat")
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        let date = formatter.date(from: "2006-03-24T22:30:00.000Z")
        XCTAssertEqual(launchDetails.date, date)
        XCTAssertEqual(launchDetails.details, "Engine failure at 33 seconds and loss of vehicle")
        XCTAssertEqual(launchDetails.rocketId, "falcon1")
    }

}
