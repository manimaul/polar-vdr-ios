//
//  TackTest.swift
//  Polar VDRTests
//
//  Created by William Kamp on 8/2/22.
//

import XCTest
@testable import Polar_VDR

class TackTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUnknown() throws {
        let subjects: [(Float, Float)] = [
            (0.0, 0.0),
            (180.0, 180.0),
            (-180.0, 180.0),
            (-540.0, 180.0),
            (540.0, 180.0),
        ]
        subjects.forEach { each in
            let tack = each.0.windDegreesAsTack()
            XCTAssertEqual(tack, .unknown(each.1))
        }
    }

    func testPortWrap() throws {
        let subjects: [(Float, Float)] = [
            (360.1, 0.1),
            (-270.2, 89.8),
            (-1350.2, 89.8),
        ]
        subjects.forEach { each in
            let tack = each.0.windDegreesAsTack()
            switch tack {
            case .port(let value):
                XCTAssertEqual(value, each.1, accuracy: 0.001)
            case .starboard(let value):
                XCTFail("expected port was starboard for value <\(value)>")
            case .unknown(let value):
                XCTFail("expected port was unknown for value <\(value)>")
            }
        }
    }
    
    func testPortNeg() throws {
        for each: Float in stride(from: -359.9, to: -180.1, by: 0.1) {
            let tack = each.windDegreesAsTack()
            switch tack {
            case .port(_):
                print("")
            case .starboard(let value):
                XCTFail("expected port was starboard for value <\(value)>")
            case .unknown(let value):
                XCTFail("expected port was unknown for value <\(value)>")
            }
        }
    }

    func testPort() throws {
        for each: Float in stride(from: 0.1, to: 179.9, by: 0.1) {
            let tack = each.windDegreesAsTack()
            XCTAssertEqual(tack, .port(each))
        }
    }
    
    func testStarboardNeg() throws {
        for each: Float in stride(from: -179.9, to:-0.1 , by: 0.1) {
            let tack = each.windDegreesAsTack()
            switch tack {
            case .port(let value):
                XCTFail("expected starboard was port for value <\(value)>")
            case .starboard(_):
                print("")
            case .unknown(let value):
                XCTFail("expected port was unknown for value <\(value)>")
            }
        }
    }
    
    func testStarboard() throws {
        for each: Float in stride(from: 180.1, to: 359.9, by: 0.1) {
            let tack = each.windDegreesAsTack()
            XCTAssertEqual(tack, .starboard(each))
        }
    }

    func testStarboardWrap() throws {
        let subjects: [(Float, Float)] = [
            (1350.2, 270.2),
            (540.1, 180.1),
        ]
        subjects.forEach { each in
            let tack = each.0.windDegreesAsTack()
            switch tack {
            case .port(let value):
                XCTFail("expected starboard was port for value <\(value)>")
            case .starboard(let value):
                XCTAssertEqual(value, each.1, accuracy: 0.001)
            case .unknown(let value):
                XCTFail("expected port was unknown for value <\(value)>")
            }
        }
    }
}
