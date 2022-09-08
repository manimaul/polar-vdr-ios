//
//  ContentView.swift
//  Polar VDR
//
//  Created by William Kamp on 7/23/22.
//

import SwiftUI

struct NavDataEntry<T> {
    let data: T
    let time: Double
}

protocol Expirable {
    var time: Date { get }
}

struct NavValue<T>: Expirable {
    let time: Date = Date()
    let value: T
}

struct NavHeading : Expirable {
    let time: Date = Date()
    let angle: Angle
    let magnetic: Bool
}

class Global: ObservableObject {
    func invalidate() {
        let now = Date()
        if let t = navSTW?.time {
            if now.timeIntervalSince(t) > 3 {
                navSTW = nil
            }
        }
        if let t = navSOG?.time {
            if now.timeIntervalSince(t) > 3 {
                navSOG = nil
            }
        }
        if let t = navTWS?.time {
            if now.timeIntervalSince(t) > 3 {
                navTWS = nil
            }
        }
        if let t = navAWS?.time {
            if now.timeIntervalSince(t) > 3 {
                navAWS = nil
            }
        }
        if let t = navTWA?.time {
            if now.timeIntervalSince(t) > 3 {
                navTWA = nil
            }
        }
        if let t = navAWA?.time {
            if now.timeIntervalSince(t) > 3 {
                navAWA = nil
            }
        }
        if let t = navHeading?.time {
            if now.timeIntervalSince(t) > 3 {
                navHeading = nil
            }
        }
        if let t = navCOG?.time {
            if now.timeIntervalSince(t) > 3 {
                navCOG = nil
            }
        }
    }

    @Published var boat: Boat = selectedBoat() {
        didSet {
            print("saving selected boat \(boat.name)")
            saveSelectedBoat(name: boat.name)
        }
    }
    @Published var navHeading: NavHeading? = nil
    @Published var navSTW: NavValue<Double>? = nil
    @Published var navSOG: NavValue<Double>? = nil
    @Published var navAWS: NavValue<Double>? = nil
    @Published var navTWS: NavValue<Double>? = nil
    @Published var navTWA: NavValue<Angle>? = nil
    @Published var navAWA: NavValue<Angle>? = nil
    @Published var navCOG: NavHeading? = nil
    @Published var polarEFF: NavValue<Double>? = nil
}

let globalState = Global()

struct ContentView: View {
    @StateObject var global = globalState

    var body: some View {
        TabView {
            DashView().tabItem {
                Image(systemName: "speedometer")
                Text("Dash")
            }
            LogsView().tabItem {
                Image(systemName: "book")
                Text("Logs")
            }
            ChartView().tabItem {
                Image(systemName: "map")
                Text("Chart")
            }
            ConfigView().tabItem {
                Image(systemName: "wrench")
                Text("Config")
            }
        }.environmentObject(global)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
