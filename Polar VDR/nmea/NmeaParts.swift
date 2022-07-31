//
//  NmeaParts.swift
//  Polar VDR
//
//  Created by William Kamp on 7/28/22.
//

import Foundation

class NmeaParts {
    let data: Data

    init?(data: Data?) {
        if let data = data {
            self.data = data
        } else {
            return nil
        }
    }

    init?(line: String?) {
        if let data = line?.data(using: .ascii) {
            self.data = data
        } else {
            return nil
        }
    }

    lazy var isValid: Bool = {
        isValidChecksum()
    }()

    lazy var talker: String? = {
        if (sentence.count > 3) {
            let start = sentence.index(sentence.startIndex, offsetBy: 1)
            if let comma = sentence.firstIndex(of: nmeaDelimChar) {
                if let end = sentence.index(comma, offsetBy: -4, limitedBy: sentence.startIndex) {
                    if (start < end) {
                        return String(sentence[start...end])
                    }
                }
            }
        }
        return nil
    }()

    lazy var id: String = {
        if (sentence.count > 3) {
            let start = sentence.index(sentence.startIndex, offsetBy: 3)
            if let comma = sentence.firstIndex(of: nmeaDelimChar) {
                let end = sentence.index(comma, offsetBy: -1)
                if (start < end) {
                    return String(sentence[start...end])
                }
            }
        }
        return ""
    }()

    lazy var sentence: String = {
        if let line = String(data: data, encoding: .ascii) {
            return line
        } else {
            return ""
        }
    }()

    /*
     example: $GPGGA,220222.00,4716.79372,N,12224.01493,W,2,09,0.9,3.0,M,-18.7,M,7.0,0131*71
               |------------------------------------------------------------------------|     payload
                                                                                          71  checksum
               GP talker
                 GGA id
     */
    private func isValidChecksum() -> Bool {
        if (data.count >= 1 &&
                data.count <= nmeaMaxLen && (data[0] == nmeaBeginDollar || data[0] == nmeaBeginExclam)) {
            if let payloadEnd = data.firstIndex(of: nmeaChecksum) { // * char delimiter before checksum
                let payload = data.subdata(in: data.startIndex + 1..<payloadEnd)
                let calculatedSum = makeChecksum(payload: payload, start: 0)
                let sumData = data.subdata(in: payloadEnd + 1..<data.endIndex)
                let sum = String(data: sumData, encoding: .ascii)
                return sum == calculatedSum
            }
        }
        return false
    }

    private func makeChecksum(payload: Data, start: Int) -> String {
        var sum: UInt8 = 0
        for (index, each) in payload.enumerated() {
            if (index >= start) {
                sum = sum ^ each
            }
        }
        return String(format:"%02X", sum) // hex
    }
}
