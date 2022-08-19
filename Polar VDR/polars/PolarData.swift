//
//  PolarData.swift
//  Polar VDR
//
//  Created by William Kamp on 7/31/22.
//

import Foundation

let twsTwa = "twa/tws"

struct PolarEntry: Hashable {
    let twa: Float
    let tws: Float
    let stw: Float
}

fileprivate func createPolarData(csv: [String]) -> [PolarEntry]? {
    if (csv.count < 1) {
        return nil
    }
    var data: [PolarEntry] = []
    var twSpeeds: [Float] = []
    let twsLine = csv[0]
    if twsLine.hasPrefix(twsTwa) {
        twsLine.split(separator: ";").forEach { sequence in
            if let s = Float(sequence) {
                twSpeeds.append(s)
            }
        }
    } else {
        print("csv missing <\(twsTwa)> line")
        return nil
    }

    for (index, line) in csv.enumerated() {
        if index > 0 {
            let values = line.split(separator: ";")
            if values.count != twSpeeds.count + 1 {
                print("wrong number of values in line[\(index)]")
                return nil
            }
            guard let twa = Float(values[0]) else {
                print("could not determine twa line[\(index)]")
                return nil
            }
            for (vi, value) in values.enumerated() {
                if (vi > 0) {
                    //"52;5.53;6.51;6.98;7.17;7.28;7.34;7.4",
                    guard let stw = Float(value) else {
                        print("could not determine stw line[\(index)][\(vi)")
                        return nil
                    }
                    let entry = PolarEntry(twa: twa, tws: twSpeeds[vi - 1], stw: stw)
                    //only allow zero water speeds where the wind speed is GT zero
                    if entry.tws == 0.0 || entry.stw > 0.0 {
                        data.append(entry)
                    }
                }
            }
        }
    }
    return data
}

fileprivate func sortIndex(index: [Float: [PolarEntry]]) {

}

fileprivate func createIndex(data: [PolarEntry]) -> [Float: [PolarEntry]] {
    var index = [Float: [PolarEntry]]()
    (0...data.count - 1).forEach { i in
        let d = data[i]
        index[d.tws, default: []].append(d)
    }
    index.keys.forEach { key in
        index[key]?.sort { entry, entry2 in
            entry.twa < entry2.twa
        }
    }
    return index
}

class PolarData {

    let data: [PolarEntry]
    let twsIndex: [Float: [PolarEntry]]
    lazy var twsKeys: [Float] = {
        Array(twsIndex).sorted(by: { $0.0 < $1.0 }).map { each in
            each.key
        }
    }()

    func entryForSpeed(tws: Float) -> [PolarEntry]? {
        let key: Float? = twsKeys.first { k in
            //first tws key where tws is LTEQ key && within 2 kts
            tws <= k && k - tws < 2.0
        }
        if let key = key {
            return twsIndex[key]
        }
        return nil
    }

    init?(csvFileContents: String) {
        if let data = createPolarData(csv: csvFileContents.components(separatedBy: "\n")) {
            self.data = data
            self.twsIndex = createIndex(data: data)
        } else {
            return nil
        }
    }

    init?(csvLines: [String]) {
        if let data = createPolarData(csv: csvLines) {
            self.data = data
            self.twsIndex = createIndex(data: data)
        } else {
            return nil
        }
    }

    /**
     - Parameters:
       - stw: speed through the water in knots
       - twa: true wind angle in degrees
       - tws: true wind speed in knots
     - Returns: A percentage
     */
    func calculateEfficiency(stw: Float, twa: Float, tws: Float) -> Float {
        return 0.0
    }

    func calculatePolarSpeed(twa: Float, tws: Float) -> Float {
        return 0.0
    }
}
