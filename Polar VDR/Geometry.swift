//
// Created by William Kamp on 8/2/22.
//

import SwiftUI

extension CGPoint {
    func project(distance: CGFloat, degrees: Double) -> CGPoint {
        let offsetDeg = degrees - 90
        let alpha = offsetDeg * Double.pi / 180.0
        var endPoint = CGPoint()
        endPoint.x = x + (distance * cos(alpha))
        endPoint.y = y + (distance * sin(alpha))
        return endPoint
    }

    func distanceSquared(to: CGPoint) -> CGFloat {
        (x - to.x) * (x - to.x) + (y - to.y) * (y - to.y)
    }

    func distance(to: CGPoint) -> CGFloat {
        sqrt(distanceSquared(to: to))
    }

    func midPoint(to: CGPoint) -> CGPoint {
        CGPoint(x: (x + to.x) / 2.0, y: (y + to.y) / 2.0)
    }

    func angle(to: CGPoint) -> Angle {
        let originX = to.x - x
        let originY = to.y - y
        var radians = atan2(originY, originX)

        while radians < 0 {
            radians += CGFloat(2 * Double.pi)
        }
        return (Angle(radians: radians) - Angle(degrees: 90))
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

struct CGLine {
    let start: CGPoint
    let end: CGPoint

    func intersection(line: CGLine) -> CGPoint? {
        // calculate the differences between the start and end X/Y positions for each of our points
        let delta1x = end.x - start.x
        let delta1y = end.y - start.y
        let delta2x = line.end.x - line.start.x
        let delta2y = line.end.y - line.start.y

        // create a 2D matrix from our vectors and calculate the determinant
        let determinant = delta1x * delta2y - delta2x * delta1y

        if abs(determinant) < 0.0001 {
            // if the determinant is effectively zero then the lines are parallel/colinear
            return nil
        }

        // if the coefficients both lie between 0 and 1 then we have an intersection
        let ab = ((start.y - line.start.y) * delta2x - (start.x - line.start.x) * delta2y) / determinant

        if ab > 0 && ab < 1 {
            let cd = ((start.y - line.start.y) * delta1x - (start.x - line.start.x) * delta1y) / determinant

            if cd > 0 && cd < 1 {
                // lines cross – figure out exactly where and return it
                let intersectX = start.x + ab * delta1x
                let intersectY = start.y + ab * delta1y
                return CGPoint(x: intersectX, y: intersectY)
            }
        }

        // lines don't cross
        return nil
    }
}
