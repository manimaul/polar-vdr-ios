//
//  Polar_VDRTests.swift
//  Polar VDRTests
//
//  Created by William Kamp on 7/23/22.
//

import XCTest
@testable import Polar_VDR

class Polar_VDRTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNmeaParts_GGA() throws {
        var subject = NmeaParts(line: "$GPGGA,220222.00,4716.79372,N,12224.01493,W,2,09,0.9,3.0,M,-18.7,M,7.0,0131*71")!
        XCTAssertTrue(subject.isValid)
        XCTAssertEqual(subject.id, "GGA")
        XCTAssertEqual(subject.talker!, "GP")
    }

    func testNmeaParts_VDM() throws {
        var subject = NmeaParts(line: "!AIVDM,1,1,,A,403Ot`1v><n2Fo=sdRK=Bbg02<<e,0*54")!
        XCTAssertTrue(subject.isValid)
        XCTAssertEqual(subject.id, "VDM")
        XCTAssertEqual(subject.talker!, "AI")
    }

    func testNmeaPartsInvalid() throws {
        [",", "", "$*,", ",,", ",,,", "$,,,,,,,,,,,,,,,,,,,,,,", "!", "$"].forEach { line in
            var subject = NmeaParts(line: line)!
            XCTAssertFalse(subject.isValid)
            XCTAssertEqual(subject.id, "")
            XCTAssertNil(subject.talker)
        }
    }
}
