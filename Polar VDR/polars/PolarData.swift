//
//  PolarData.swift
//  Polar VDR
//
//  Created by William Kamp on 7/31/22.
//

import Foundation

let twsTwa = "twa/tws"
var j35_csv = [
    "twa/tws;6;8;10;12;14;16;20",
    "0;0;0;0;0;0;0;0",
    "42.6;4.96;0;0;0;0;0;0",
    "41.4;0;5.87;0;0;0;0;0",
    "39;0;0;6.37;0;0;0;0",
    "37.5;0;0;0;6.55;0;0;0",
    "36.4;0;0;0;0;6.62;0;0",
    "35.8;0;0;0;0;0;6.67;0",
    "35.4;0;0;0;0;0;0;6.71",
    "52;5.53;6.51;6.98;7.17;7.28;7.34;7.4",
    "60;5.84;6.72;7.11;7.34;7.47;7.56;7.65",
    "75;6.08;6.86;7.22;7.51;7.75;7.92;8.1",
    "90;5.99;6.84;7.24;7.55;7.87;8.16;8.56",
    "110;5.6;6.74;7.29;7.71;8.12;8.42;8.85",
    "120;5.45;6.61;7.21;7.66;8.13;8.58;9.31",
    "135;4.95;6.11;6.91;7.37;7.81;8.29;9.37",
    "150;4.18;5.28;6.26;6.95;7.37;7.78;8.68",
    "145.1;4.41;0;0;0;0;0;0",
    "149.3;0;5.31;0;0;0;0;0",
    "151.1;0;0;6.19;0;0;0;0",
    "157.8;0;0;0;6.64;0;0;0",
    "171.2;0;0;0;0;6.8;0;0",
    "177.2;0;0;0;0;0;7.18;0",
    "177.2;0;0;0;0;0;0;7.94",
]

typealias Twa = Int
typealias Tws = Float
typealias Stw = Float


struct PolarEntry {
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
                    data.append(entry)
                }
            }
        }
    }
    return data
}

class PolarData {

    let data: [PolarEntry]

    init?(csvFileContents: String) {
        if let data = createPolarData(csv: csvFileContents.components(separatedBy: "\n")) {
            self.data = data
        } else {
            return nil
        }
    }

    init?(csvLines: [String] = j35_csv) {
        if let data = createPolarData(csv: j35_csv) {
            self.data = data
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
