//
// Created by William Kamp on 7/30/22.
//

import SwiftUI

struct PolarRadarView: View {
    @Environment(\.colorScheme) var colorScheme
    let numRings: Int

    var body: some View {
        GeometryReader { geometry in
            let dia: CGFloat = min(geometry.size.height, geometry.size.width)
            let increment: CGFloat = dia / CGFloat(numRings)
            let hullSize: CGFloat = (dia - increment * CGFloat(numRings - 1)) * 0.5
            let x = geometry.drawCenterX()
            let y = geometry.drawCenterY()

            ZStack {
                ForEach((0...numRings), id: \.self) {
                    let i: Int = $0
                    let diameter = increment * CGFloat(i)
                    if i > 0 {
                        Text("\($0) kts")
                                .position(x: x, y: y + diameter / 2.0 + 8.0).font(.system(size: 8.0)).foregroundColor(colorScheme.twsColor())
                    }
                    Circle()
                            .stroke(colorScheme.twsColor())
                            .frame(width: diameter, height: diameter, alignment: .center)
                            .position(x: x, y: y)
                }
                Image("hull").resizable()
                        .renderingMode(.template)
                        .colorMultiply(colorScheme.defaultColor())
                        .aspectRatio(contentMode: .fit).frame(height: hullSize, alignment: .center).position(x: x, y: y)
            }
        }
    }
}
