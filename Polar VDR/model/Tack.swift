//
// Created by William Kamp on 8/2/22.
//

import SwiftUI

enum Tack : Equatable {
    case port(Float)
    case starboard(Float)
    case unknown(Float)
}

extension Float {
    func windDegreesAsTack() -> Tack {
        var degrees = self.truncatingRemainder(dividingBy: 360.0)
        if (degrees < 0.0) {
           degrees += 360
        }
        if (degrees == 180.0 || degrees == 0.0) {
            return .unknown(degrees)
        }
        if (degrees > 180.0) {
            return .starboard(degrees)
        } else {
            return .port(degrees)
        }
    }
}
