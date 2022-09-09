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

    func bgColor() -> Color {
        switch (self) {
        case .light:
            return .white
        case .dark:
            return .black
        @unknown default:
            return .gray
        }
    }

    func hdtColor() -> Color {
        .green
    }

    func cogColor() -> Color {
        switch (self) {
        case .light:
            return hdtColor().darker(by: 50)
        case .dark:
            return hdtColor().lighter(by: 50)
        @unknown default:
            return hdtColor()
        }
    }

    func twsColor() -> Color {
        switch (self) {
        case .light:
            return .purple.darker()
        case .dark:
            return .purple.lighter()
        @unknown default:
            return .purple
        }
    }

    func awsColor() -> Color {
        switch (self) {
        case .light:
            return twsColor().darker()
        case .dark:
            return twsColor().lighter()
        @unknown default:
            return twsColor()
        }
    }

    func stwColor() -> Color {
        switch (self) {
        case .light:
            return .red.darker(by: 40.0)
        case .dark:
            return .red
        @unknown default:
            return .red
        }
    }

    func sogColor() -> Color {
        switch (self) {
        case .light:
            return stwColor().darker()
        case .dark:
            return stwColor().lighter()
        @unknown default:
            return stwColor()
        }
    }

    func twaColor() -> Color {
        switch (self) {
        case .light:
            return .yellow.darker(by: 40.0)
        case .dark:
            return .yellow
        @unknown default:
            return .yellow
        }
    }

    func awaColor() -> Color {
        switch (self) {
        case .light:
            return twaColor().darker()
        case .dark:
            return twaColor().lighter()
        @unknown default:
            return twaColor()
        }
    }
}

extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            return (0, 0, 0, 0)
        }
        return (r, g, b, o)
    }

    func lighter(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: abs(percentage))
    }

    func darker(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: -1 * abs(percentage))
    }

    func adjust(by percentage: CGFloat = 30.0) -> Color {
        return Color(red: min(Double(self.components.red + percentage / 100), 1.0),
                green: min(Double(self.components.green + percentage / 100), 1.0),
                blue: min(Double(self.components.blue + percentage / 100), 1.0),
                opacity: Double(self.components.opacity))
    }
}