//
// Created by William Kamp on 8/4/22.
//

import SwiftUI

extension ColorScheme {
    func defaultColor() -> Color {
        switch (self) {
        case .light:
            return .black
        case .dark:
            return .white
        @unknown default:
            return .gray
        }
    }

    func cogColor() -> Color {
        .red
    }

    func hdtColor() -> Color {
        .green
    }

    func twsColor() -> Color {
        .purple
    }
}