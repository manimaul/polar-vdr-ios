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
