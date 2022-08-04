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
    func drawCenterX() -> CGFloat {
        size.width / 2.0
    }

    func drawCenterY() -> CGFloat {
        size.height / 2.0
    }
}
