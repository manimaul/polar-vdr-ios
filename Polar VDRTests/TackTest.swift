//
//  TackTest.swift
//  Polar VDRTests
//
//  Created by William Kamp on 8/2/22.
//

import XCTest
import SwiftUI
@testable import Polar_VDR

class TackTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUnknown() throws {
        let subjects: [(Angle, Double)] = [
            (Angle(degrees: 0.0), 0.0),
            (Angle(degrees: 180.0), 180.0),
            (Angle(degrees: -180.0), 180.0),
            (Angle(degrees: -540.0), 180.0),
            (Angle(degrees: 540.0), 180.0),
        ]
        subjects.forEach { each in
            let tack = each.0.windDegreesAsTack()
            XCTAssertEqual(tack, .unknown)
            XCTAssertEqual(each.0.degreesNormal(), each.1, accuracy: 0.001)
        }
    }

    func testPortWrap() throws {
        let subjects: [(Angle, Double)] = [
            (Angle(degrees: 360.1), 0.1),
            (Angle(degrees: -270.2), 89.8),
            (Angle(degrees: -1350.2), 89.8),
        ]
        subjects.forEach { each in
            let tack = each.0.windDegreesAsTack()
            XCTAssertEqual(tack, .port)
            XCTAssertEqual(each.0.degreesNormal(), each.1, accuracy: 0.001)
        }
    }

    func testPortNeg() throws {
        for each: Double in stride(from: -359.9, to: -180.1, by: 0.1) {
            let tack = Angle(degrees: each).windDegreesAsTack()
            XCTAssertEqual(tack, .port)
        }
    }

    func testPort() throws {
        for each: Double in stride(from: 0.1, to: 179.9, by: 0.1) {
            let tack = Angle(degrees: each).windDegreesAsTack()
            XCTAssertEqual(tack, .port)
        }
    }

    func testStarboardNeg() throws {
        for each: Double in stride(from: -179.9, to:-0.1 , by: 0.1) {
            let tack = Angle(degrees: each).windDegreesAsTack()
            XCTAssertEqual(tack, .starboard)
        }
    }

    func testStarboard() throws {
        for each: Double in stride(from: 180.1, to: 359.9, by: 0.1) {
            let tack = Angle(degrees: each).windDegreesAsTack()
            XCTAssertEqual(tack, .starboard)
        }
    }

    func testStarboardWrap() throws {
        let subjects: [(Angle, Double)] = [
            (Angle(degrees: 1350.2), 270.2),
            (Angle(degrees: 540.1), 180.1),
        ]
        subjects.forEach { each in
            let tack = each.0.windDegreesAsTack()
            XCTAssertEqual(tack, .starboard)
            XCTAssertEqual(each.0.degreesNormal(), each.1, accuracy: 0.001)
        }
    }
}
