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
    
    func testPolarData() throws {
        var subject = PolarData()
        XCTAssertNotNil(subject)
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

    /*
      $GPGGA,220222.00,4716.79372,N,12224.01493,W,2,09,0.9,3.0,M,-18.7,M,7.0,0131*71
      !AIVDM,1,1,,A,403Ot`1v><n2Fo=sdRK=Bbg02<<e,0*54
      $GPGNS,220222.00,4716.79372,N,12224.01493,W,D,09,0.9,3.0,-18.7,7.0,0131*1C
      $GPZDA,220222.00,25,08,2019,00,00*61
      $GPRMC,220222.00,A,4716.79372,N,12224.01493,W,0.07,287.18,250819,15.2,E,D*16
      $GPGSA,M,3,08,10,13,15,16,20,21,27,32,,,,1.4,0.9,1.1*3
     */

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
