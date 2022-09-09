//
//  Polar_VDRTests.swift
//  Polar VDRTests
//
//  Created by William Kamp on 7/23/22.
//

import XCTest
@testable import Polar_VDR

class NmeaPartsTest: XCTestCase {
    
    func testNmeaParts_GGA() throws {
        let subject = NmeaParts(line: "$GPGGA,220222.00,4716.79372,N,12224.01493,W,2,09,0.9,3.0,M,-18.7,M,7.0,0131*71")!
        XCTAssertTrue(subject.isValid)
        XCTAssertEqual(subject.id, "GGA")
        XCTAssertEqual(subject.talker!, "GP")
        XCTAssertEqual(subject[0], "GPGGA")
        XCTAssertEqual(subject[14], "0131")
        XCTAssertEqual(subject.componentDouble(1), 220222.0)
        XCTAssertEqual(subject.componentDouble(2), 4716.79372)

    }

    func testNmeaParts_VDM() throws {
        let subject = NmeaParts(line: "!AIVDM,1,1,,A,403Ot`1v><n2Fo=sdRK=Bbg02<<e,0*54")!
        XCTAssertTrue(subject.isValid)
        XCTAssertEqual(subject.id, "VDM")
        XCTAssertEqual(subject.talker!, "AI")
    }

    func testNmeaPartsInvalid() throws {
        [",", "", "$*,", ",,", ",,,", "$,,,,,,,,,,,,,,,,,,,,,,", "!", "$"].forEach { line in
            let subject = NmeaParts(line: line)!
            XCTAssertFalse(subject.isValid)
            XCTAssertEqual(subject.id, "")
            XCTAssertNil(subject.talker)
        }
    }
}
