//
// Created by William Kamp on 7/30/22.
//

import SwiftUI

struct RadarRingsView: View {
    var body: some View {
        GeometryReader { geometry in
            let dia = min(geometry.size.height, geometry.size.width) - (padSzLg * 2)
            let increment = dia / 5
            ZStack {
                Circle()
                        .stroke(.black)
                        .frame(width: dia, height: dia, alignment: .center)
                Circle()
                        .stroke(.black)
                        .frame(width: dia - increment * 1, height: dia - increment * 1, alignment: .center)
                Circle()
                        .stroke(.black)
                        .frame(width: dia - increment * 2, height: dia - increment * 2, alignment: .center)
                Circle()
                        .stroke(.black)
                        .frame(width: dia - increment * 3, height: dia - increment * 3, alignment: .center)
                Circle()
                        .stroke(.black)
                        .frame(width: dia - increment * 4, height: dia - increment * 4, alignment: .center)
                Circle()
                        .stroke(.black)
                        .frame(width: dia - increment * 5, height: dia - increment * 5, alignment: .center)
            }
        }
    }
}

struct PolarView: View {
    var body: some View {
        ZStack {
            RadarRingsView()
        }
    }
}


