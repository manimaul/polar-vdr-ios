//
// Created by William Kamp on 7/27/22.
//

import Foundation

// Messages have a maximum length of 82 characters, including the $ or ! starting and including the <CR><LF>
// All transmitted data are printable ASCII characters between 0x20 (space) to 0x7e (~)
// https://en.wikipedia.org/wiki/NMEA_0183
let maxNmeaLength = 82
let nmeaBeginDollarChar: Character = "$"
let nmeaBeginDollar: UInt8 = nmeaBeginDollarChar.asciiValue! //0x/24
let nmeaBeginExclamChar: Character = "!"
let nmeaBeginExclam: UInt8 = nmeaBeginExclamChar.asciiValue! // 0x21
let nmeaRangeStartChar: Character = " "
let nmeaRangeStart: UInt8 = nmeaBeginDollarChar.asciiValue! // 0x20
let nmeaRangeEndChar: Character = "~"
let nmeaRangeEnd: UInt8 = nmeaBeginDollarChar.asciiValue! // 0x7e
let nmeaChecksumChar: Character = "*"
let nmeaChecksum: UInt8 = nmeaChecksumChar.asciiValue!
let nmeaDelimChar: Character = ","
let nmeaDelim: UInt8 = nmeaDelimChar.asciiValue!
let nmeaMaxLen = 82


enum NmeaId: String {
    case rmc = "RMC" //recommended minimum navigation information
    case mwv = "MWV" //wind speed and angle
    case vtg = "VTG" //track made good and ground speed
    case vbw = "VBW" //dual ground and water speed
    case vhw = "VHW" //water speed and heading
}

protocol NmeaSentence {
    var sentence: String { get }
    var id: NmeaId { get }
}

extension NmeaSentence {

    func nmeaParts() -> NmeaParts? {
        NmeaParts(line: sentence)
    }

    func determineId() -> NmeaId? {
        NmeaId(rawValue: sentence)
    }
}

class NmeaRmc : NmeaSentence {
    let sentence: String
    let id: NmeaId = .rmc

    init?(sentence: String) {
        self.sentence = sentence
        if determineId() != id {
            return nil
        }
    }

    //kts
    lazy var cog: Float? = {
        nil
    }()

    //kts
    lazy var sog: Float? = {
        nil
    }()

    lazy var lng: Double? = {
        nil
    }()

    lazy var lat: Double? = {
        nil
    }()

    lazy var utc: Date? = {
        nil
    }()
}

/**
 MWV - Wind Speed and Angle

         1   2 3   4 5
        |   | |   | |
 $--MWV,x.x,a,x.x,a*hh<CR><LF>
 Field Number:

1 Wind Angle, 0 to 359 degrees

2 Reference, R = Relative, T = True

3 Wind Speed

4 Wind Speed Units, K/M/

6 Status, A = Data Valid, V = Invalid

Checksum
 */
class NmeaMwv : NmeaSentence {
    let sentence: String
    let id: NmeaId = .mwv

    init?(sentence: String) {
        self.sentence = sentence
        if determineId() != id {
            return nil
        }
    }

    //degrees
    lazy var windAngle: Int? = {
        nil
    }()

    //appearant or true
    lazy var trueAngle: Bool? = {
        nil
    }()

    //kts
    lazy var windSpeed: Float? = {
        nil
    }()
}
