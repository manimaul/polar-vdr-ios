//
// Created by William Kamp on 9/6/22.
//

import SwiftUI

class NmeaProcessor {

    var timer: Timer? = nil
    var seenIds: Set<String> = []

    func lazyStartTime() {
        if (timer == nil) {
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { t in
                self.printSeenIds()
                globalState.invalidate()
            }
        }
    }

    private func printSeenIds() {
        let message = seenIds.sorted().reduce("") { (acc , each)  in
            if acc.count == 0 {
                return each
            }
            return "\(acc), \(each)"
        }
//        print("messages seen \(message)")
        seenIds = []
    }

    func process(parts: NmeaParts) {
        lazyStartTime()
        seenIds.insert(parts.id)
        if !parts.isValid {
            print("invalid nmea checksum <\(parts.sentence)>")
            return
        }
        switch parts.id {
        case "VHW":
            vhw(parts)
            break;
        case "VTG":
            vtg(parts)
            break;
        case "HDT":
            break;
        case "HDG":
            break;
        case "MWV":
            mwv(parts)
            break;
        case "MWD":
            break;
        case "RMC":
            break;
        default:
            break;
        }
    }

    /**
     MWV - Wind Speed and Angle

            1   2 3   4 5
            |   | |   | |
     $--MWV,x.x,a,x.x,a*hh<CR><LF>
     1) Wind Angle, 0 to 360 degrees
     2) Reference, R = Relative, T = True
     3) Wind Speed
     4) Wind Speed Units, K/M/N
     5) Status, A = Data Valid
     6) Checksum
     */
    private func mwv(_ parts: NmeaParts) {
        if parts[5] != "A" {
            print("invalid MWV <\(parts.sentence)>")
            return
        }
        if let angle = parts.componentDouble(1) {
            if parts[2] == "T" {
                globalState.navTWA = NavValue(value: Angle(degrees: angle))
            } else if parts[2] == "R" {
                globalState.navAWA =  NavValue(value: Angle(degrees: angle))
            } else {
                print("error angle reference MWV <\(parts.sentence)>")
            }
        }

        if let speed = parts.componentDouble(3)  {
            var kts : Double? {
                switch parts[4] {
                case "K": //km/h
                    return speed * 0.539957
                case "M": //m/s
                    return speed * 1.94384
                case "N": //knots
                    return speed
                default:
                    return nil
                }
            }
            if let kts = kts {
                if parts[2] == "T" {
                    globalState.navTWS = NavValue(value: kts)
                }
                if parts[2] == "R" {
                    globalState.navAWS = NavValue(value: kts)
                }
            }
        }
    }

    /**
     Track Made Good and Ground Speed.

            1  2  3  4  5   6 7   8 9
            |  |  |  |  |   | |   | |
     $--VTG,x.x,T,x.x,M,x.x,N,x.x,K,m*hh<CR><LF> (v2.3+)
     $--VTG,x.x,T,x.x,M,x.x,N,x.x,K*hh<CR><LF>
     1) Course over ground, degrees True
     2) T = True
     3) Course over ground, degrees Magnetic
     4) M = Magnetic
     5) Speed over ground, knots
     6) N = Knots
     7) Speed over ground, km/hr
     8) K = Kilometers Per Hour
     9) FAA mode indicator (NMEA 2.3 and later)
     10- Checksum
     */
    private func vtg(_ parts: NmeaParts) {
        if (parts[2] == "T") {
            if let cog = parts.componentDouble(1) {
                globalState.navCOG = NavHeading(angle: Angle(degrees: cog), magnetic: false)
            }
        } else if (parts[4] == "M") {
            if let cog = parts.componentDouble(3) {
                globalState.navCOG = NavHeading(angle: Angle(degrees: cog), magnetic: true)
            }
        }

        if parts[6] == "N" {
            if let sog = parts.componentDouble(5) {
                globalState.navSOG = NavValue(value: sog)
            }
        }
    }

    /**
     VHW - Water speed and heading
             1   2 3   4 5   6 7   8 9
             |   | |   | |   | |   | |
      $--VHW,x.x,T,x.x,M,x.x,N,x.x,K*hh<CR><LF>
      1) Heading degrees, True
      2) T = True
      3) Heading degrees, Magnetic
      4) M = Magnetic
      5) Speed of vessel relative to the water, knots
      6) N = Knots
      7) Speed of vessel relative to the water, km/hr
      8) K = Kilometers
      9) Checksum
     */
    private func vhw(_ parts: NmeaParts) {
        if (parts.components.count == 9) {
            if (parts[2] == "T") {
                if let hdt = parts.componentDouble(1) {
                    globalState.navHeading = NavHeading(angle: Angle(degrees: hdt), magnetic: false)
                }
            } else if (parts[4] == "M") {
                if let hdg = parts.componentDouble(3) {
                    globalState.navHeading = NavHeading(angle: Angle(degrees: hdg), magnetic: true)
                }
            }

            if (parts[6] == "N") {
                if let stw = parts.componentDouble(5) {
                    globalState.navSTW = NavValue(value: stw)
                }
            }
        }
    }
}