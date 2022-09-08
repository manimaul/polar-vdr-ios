//
// Created by William Kamp on 8/2/22.
//

import SwiftUI

enum Tack {
    case port
    case starboard
    case unknown
}

extension Angle {
    func degreesNormal() -> Double {
        var degreesNormal = degrees.truncatingRemainder(dividingBy: 360.0)
        if (degreesNormal < 0.0) {
            degreesNormal += 360
        }
        return degreesNormal
    }

    func degreesApparent() -> Double {
        var degreesNormal = degrees.truncatingRemainder(dividingBy: 360.0)
        if (degreesNormal < 0.0) {
            degreesNormal += 360
        }
        if degreesNormal > 180.0 {
            degreesNormal = -(360.0 - degreesNormal)
        }
        return degreesNormal
    }

    func windDegreesAsTack() -> Tack {
        let dn = degreesNormal()
        if (dn == 180.0 || dn == 0.0) {
            return .unknown
        }
        if (dn > 180.0) {
            return .starboard
        } else {
            return .port
        }
    }
}
