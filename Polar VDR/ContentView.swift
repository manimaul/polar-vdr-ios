//
//  ContentView.swift
//  Polar VDR
//
//  Created by William Kamp on 7/23/22.
//

import SwiftUI

struct Config: View {
    @State var hostName: String = ""
    @State var port: String = ""
    var modes = ["TCP", "UDP"]
    @State private var selectedMode = "TCP"
    @State var sog: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("NMEA Data")
                HStack {
                    TextField("Host", text: $hostName)
                    Text(":")
                    TextField("Port", text: $port)
                }
                HStack {
                    Circle().fill(.red).frame(width: 15, height: 15, alignment: .center)
                    Text("invalid")
                    Picker("Please select a mode", selection: $selectedMode) {
                        ForEach(modes, id: \.self) {
                            Text($0)
                        }
                    }
                }
                HStack {
                    Button("View data") {
                        
                    }
                    Toggle("Use SOG for STW", isOn: $sog)
                }
            }.navigationTitle("Configuration")
        }
    }
}

struct Logs: View {
    var body: some View {
        VStack {
            Text("All Logs")
        }
    }
}

struct Dash: View {
    var body: some View {
        VStack {
            Text("Dashboard")
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            Dash().tabItem {
                Image(systemName: "speedometer")
                Text("Dash")
            }
            Logs().tabItem {
                Image(systemName: "book")
                Text("Logs")
            }
            Config().tabItem {
                Image(systemName: "wrench")
                Text("Config")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
