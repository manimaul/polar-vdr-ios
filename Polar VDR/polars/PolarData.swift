//
//  PolarData.swift
//  Polar VDR
//
//  Created by William Kamp on 7/31/22.
//

import Foundation

let twsTwa = "twa/tws"

struct PolarEntry: Hashable {
    let twa: Double
    let tws: Double
    let stw: Double
}

fileprivate func createPolarData(csv: [String]) -> [PolarEntry]? {
    if (csv.count < 1) {
        return nil
    }
    var data: [PolarEntry] = []
    var twSpeeds: [Double] = []
    let twsLine = csv[0]
    if twsLine.hasPrefix(twsTwa) {
        twsLine.split(separator: ";").forEach { sequence in
            if let s = Double(sequence) {
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
            guard let twa = Double(values[0]) else {
                print("could not determine twa line[\(index)]")
                return nil
            }
            for (vi, value) in values.enumerated() {
                if (vi > 0) {
                    //"52;5.53;6.51;6.98;7.17;7.28;7.34;7.4",
                    guard let stw = Double(value) else {
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

fileprivate func sortIndex(index: [Double: [PolarEntry]]) {

}

fileprivate func createIndex(data: [PolarEntry]) -> [Double: [PolarEntry]] {
    var index = [Double: [PolarEntry]]()
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
    let twsIndex: [Double: [PolarEntry]]
    lazy var twsKeys: [Double] = {
        Array(twsIndex).sorted(by: { $0.0 < $1.0 }).map { each in
            each.key
        }
    }()

    lazy var maxStw: Double? = calcMaxStw()

    private func calcMaxStw() -> Double? {
        var maxFound: Double? = nil
        data.forEach { entry in
            maxFound = max(maxFound ?? 0, entry.stw)
        }
        return maxFound
    }

    func entryForSpeed(tws: Double) -> [PolarEntry]? {
        let key: Double? = twsKeys.first { k in
            //first tws key where tws is LTEQ key && within 2 kts
            tws <= k //&& k - tws < 2.0
        }
        if let key = key {
            return twsIndex[key]
        }
        print("could not find polar entry for tws <\(tws)>")
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
    func calculateEfficiency(stw: Double, twa: Double, tws: Double) -> Double {
        return 0.0
    }

    func calculatePolarSpeed(twa: Double, tws: Double) -> Double {
        return 0.0
    }
}
