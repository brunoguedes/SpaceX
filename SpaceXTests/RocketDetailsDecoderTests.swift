//
//  RocketDetailsDecoderTests.swift
//  SpaceXTests
//
//  Created by Bruno Guedes on 18/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import XCTest
@testable import SpaceX

class RocketDetailsDecoderTests: XCTestCase {

    func testJsonDecoder() {
        let path = Bundle(for: type(of: self)).path(forResource: "RocketDetails", ofType: "json")
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        guard let rocketDetails = try? JSONDecoder().decode(RocketDetails.self, from: jsonData!) else {
            fatalError()
        }
        XCTAssertEqual(rocketDetails.rocketName, "Falcon 9")
        XCTAssertEqual(rocketDetails.details, "Falcon 9 is a two-stage rocket designed and manufactured by SpaceX for the reliable and safe transport of satellites and the Dragon spacecraft into orbit.")
        XCTAssertEqual(rocketDetails.wikipediaURL, URL(string: "https://en.wikipedia.org/wiki/Falcon_9"))
    }

}
