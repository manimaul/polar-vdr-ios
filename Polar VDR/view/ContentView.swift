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
    @Published var navSTW: NavValue<Double>? = nil {
        didSet {
            refreshEff()
        }
    }
    @Published var polar: [PolarEntry]? = nil
    @Published var navSOG: NavValue<Double>? = nil {
        didSet {
            if sog {
                refreshEff()
            }
        }
    }
    @Published var navAWS: NavValue<Double>? = nil
    @Published var navTWS: NavValue<Double>? = nil {
        didSet {
            if let tws = navTWS?.value {
                polar = boat.polar.entryForSpeed(tws: tws)
            }
            refreshEff()
        }
    }
    @Published var navTWA: NavValue<Angle>? = nil {
        didSet {
            refreshEff()
        }
    }
    @Published var navAWA: NavValue<Angle>? = nil
    @Published var navCOG: NavHeading? = nil
    @Published var polarEFF: NavValue<Double>? = nil
    @Published var sog: Bool = UserDefaults.standard.bool(forKey: "sog4stw")

    private func refreshEff() {
        guard let tws = navTWS?.value else { return }
        var stw: Double? = nil
        if sog {
            stw = navSOG?.value
        } else {
            stw = navSTW?.value
        }
        guard let stw = stw else { return }
        guard let twa = navTWA?.value else { return }
        polarEFF = NavValue(value: boat.polar.calculateEfficiency(stw: stw, twa: twa.degreesNormal(), tws: tws))
    }
}

class TcpState: ObservableObject {
    func portChange(_ value: String) {
        if port != value {
            port = value
            UserDefaults.standard.set(port, forKey: "port")
            globalTcp.stop()
        }
    }

    func hostChange(_ value: String) {
        if host != value {
            host = value
            UserDefaults.standard.set(value, forKey: "hostName")
            globalTcp.stop()
        }
    }

    @Published var status: String = "disconnected"
    @Published var color: Color = .red
    @Published var recording: Bool = false
    @Published var validData: Bool = false
    @Published var connected: Bool = false

    @Published var host: String? = UserDefaults.standard.string(forKey: "hostName")
    @Published var port: String? = UserDefaults.standard.string(forKey: "port")

    func tick() {
        if let h = host {
            if let p = Int(port ?? "") {
                globalTcp.connect(hostName: h, port: p)
            }
        }
    }
}

let globalState = Global()
let globalTcpState = TcpState()
let globalTcp = TcpNet()

struct ContentView: View {
    @StateObject var global = globalState
    @StateObject var tcpState = globalTcpState

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
        }.environmentObject(global).environmentObject(tcpState)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
