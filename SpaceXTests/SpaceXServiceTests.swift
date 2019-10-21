//
//  SpaceXServiceTests.swift
//  SpaceXTests
//
//  Created by Bruno Guedes on 19/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxBlocking
@testable import SpaceX

class SpaceXServiceTests: XCTestCase {
    
    let disposeBag = DisposeBag()
    let dateFormatter = ISO8601DateFormatter()
    
    override func setUp() {
        dateFormatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - GetLaunches
    
    func testGetLaunches() {
        let mockBaseService = MockBaseService()
        mockBaseService.mockResponse = .launches
        let spaceXService = SpaceXService(baseService: mockBaseService)
        let result = spaceXService.getLaunches().toBlocking().materialize()
        switch result {
        case .completed(let elements):
            guard let launches = elements.first as Launches? else {
                XCTFail("Invalid launchDetails")
                return
            }
            XCTAssertEqual(launches.count,  104)
            
            XCTAssertEqual(launches[0].missionName, "FalconSat")
            XCTAssertEqual(launches[0].flightNumber, 1)
            XCTAssertEqual(launches[0].launchSuccess, .fail)
            XCTAssertEqual(launches[0].date, dateFormatter.date(from: "2006-03-24T22:30:00.000Z"))
            
            XCTAssertEqual(launches[10].missionName, "CASSIOPE")
            XCTAssertEqual(launches[10].flightNumber, 11)
            XCTAssertEqual(launches[10].launchSuccess, .success)
            XCTAssertEqual(launches[10].date, dateFormatter.date(from: "2013-09-29T16:00:00.000Z"))
            
            XCTAssertEqual(launches[22].missionName, "TürkmenÄlem 52°E / MonacoSAT")
            XCTAssertEqual(launches[22].flightNumber, 23)
            XCTAssertEqual(launches[22].launchSuccess, .success)
            XCTAssertEqual(launches[22].date, dateFormatter.date(from: "2015-04-27T23:03:00.000Z"))
            
            XCTAssertEqual(launches[63].missionName, "CRS-15")
            XCTAssertEqual(launches[63].flightNumber, 64)
            XCTAssertEqual(launches[63].launchSuccess, .success)
            XCTAssertEqual(launches[63].date, dateFormatter.date(from: "2018-06-29T09:42:00.000Z"))
            
            XCTAssertEqual(launches[81].missionName, "CRS-18")
            XCTAssertEqual(launches[81].flightNumber, 82)
            XCTAssertEqual(launches[81].launchSuccess, .success)
            XCTAssertEqual(launches[81].date, dateFormatter.date(from: "2019-07-25T22:01:00.000Z"))
            
            XCTAssertEqual(launches[103].missionName, "Smallsat SSO Rideshare 2 (Mission 9)")
            XCTAssertEqual(launches[103].flightNumber, 104)
            XCTAssertEqual(launches[103].launchSuccess, .scheduled)
            XCTAssertEqual(launches[103].date, dateFormatter.date(from: "2020-10-01T00:00:00.000Z"))
        case .failed(_, let error):
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFailedGetLaunches() {
        let mockBaseService = MockBaseService()
        mockBaseService.mockResponse = .empty
        let spaceXService = SpaceXService(baseService: mockBaseService)
        let result = spaceXService.getLaunches().toBlocking().materialize()
        switch result {
        case .completed:
            XCTFail("This call should have failed")
        case .failed(_, let error):
            XCTAssertEqual(error.localizedDescription, BaseServiceError.invalidJSON.localizedDescription)
        }
    }
    
    // MARK: - GetLaunchDetails
    
    func testSuccessfulGetLaunchDetails() {
        let mockBaseService = MockBaseService()
        mockBaseService.mockResponse = .launchDetails
        let spaceXService = SpaceXService(baseService: mockBaseService)
        let result = spaceXService.getLaunchDetails(for: 1).toBlocking().materialize()
        switch result {
        case .completed(let elements):
            guard let launchDetails = elements.first as LaunchDetails? else {
                XCTFail("Invalid launchDetails")
                return
            }
            XCTAssertEqual(launchDetails.flightNumber, 1)
            XCTAssertEqual(launchDetails.missionName, "FalconSat")
            XCTAssertEqual(launchDetails.date, dateFormatter.date(from: "2006-03-24T22:30:00.000Z"))
            XCTAssertEqual(launchDetails.launchSiteName, "Kwajalein Atoll Omelek Island")
            XCTAssertEqual(launchDetails.rocketId, "falcon1")
        case .failed(_, let error):
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFailedGetLaunchDetails() {
        let mockBaseService = MockBaseService()
        mockBaseService.mockResponse = .empty
        let spaceXService = SpaceXService(baseService: mockBaseService)
        let result = spaceXService.getLaunchDetails(for: 0).toBlocking().materialize()
        switch result {
        case .completed:
            XCTFail("This call should have failed")
        case .failed(_, let error):
            XCTAssertEqual(error.localizedDescription, BaseServiceError.invalidJSON.localizedDescription)
        }
    }
    
    // MARK: - GetRocketDetails
    
    func testSuccessfulGetRocketDetails() {
        let mockBaseService = MockBaseService()
        mockBaseService.mockResponse = .rocketDetails
        let spaceXService = SpaceXService(baseService: mockBaseService)
        let result = spaceXService.getRocketDetails(for: "falcon9").toBlocking().materialize()
        switch result {
        case .completed(let elements):
            guard let rocketDetails = elements.first as RocketDetails? else {
                XCTFail("Invalid rocketDetails")
                return
            }
            XCTAssertEqual(rocketDetails.rocketName, "Falcon 9")
            XCTAssertEqual(rocketDetails.details, "Falcon 9 is a two-stage rocket designed and manufactured by SpaceX for the reliable and safe transport of satellites and the Dragon spacecraft into orbit.")
            XCTAssertEqual(rocketDetails.wikipediaURL, URL(string: "https://en.wikipedia.org/wiki/Falcon_9"))
        case .failed(_, let error):
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFailedGetRocketDetails() {
        let mockBaseService = MockBaseService()
        mockBaseService.mockResponse = .empty
        let spaceXService = SpaceXService(baseService: mockBaseService)
        let result = spaceXService.getRocketDetails(for: "some_rocket").toBlocking().materialize()
        switch result {
        case .completed:
            XCTFail("This call should have failed")
        case .failed(_, let error):
            XCTAssertEqual(error.localizedDescription, BaseServiceError.invalidJSON.localizedDescription)
        }
    }
    
}
