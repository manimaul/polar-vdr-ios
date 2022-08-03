//
// Created by William Kamp on 8/2/22.
//

import SwiftUI

extension CGPoint {
    func pointFromPoint(distance: CGFloat, degrees: Double) -> CGPoint {
        let offsetDeg = degrees - 90
        let alpha = offsetDeg * Double.pi / 180.0
        var endPoint = CGPoint()
        endPoint.x = x + (distance * cos(alpha))
        endPoint.y = y + (distance * sin(alpha))
        return endPoint
    }
}

extension Int {
    func degreesToRadians() -> Double {
        Double(self) * Double.pi / 180.0
    }
}

extension GeometryProxy {
    func drawCenterX(tack: Tack) -> CGFloat {
        switch tack {
        case .port, .unknown:
            return 0.0 + padSzLg
        case .starboard:
            return size.width - padSzLg
        }
    }

    func drawCenterY() -> CGFloat {
        size.height / 2.0
    }
}
