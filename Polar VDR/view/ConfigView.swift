//
//  Config.swift
//  Polar VDR
//
//  Created by William Kamp on 7/24/22.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

var tcpNet: TcpNet? = nil

struct ConfigView: View {
    @EnvironmentObject var global: Global

    @State var hostName: String = UserDefaults.standard.string(forKey: "hostName") ?? ""
    @State var port: String = UserDefaults.standard.string(forKey: "port") ?? ""
    @State var sog: Bool = UserDefaults.standard.bool(forKey: "sog4stw")
    @State var record: Bool = false
    @State var color: Color = .red
    @State private var boat: String = selectedBoat().name

    var body: some View {
        VStack {
            Text("Settings").fontWeight(.heavy)
            VStack(alignment: .leading) {

                Divider()

                Group {
                    Text("Polar profile:").bold()
                    Picker("", selection: $boat) {
                        ForEach(boatNames, id: \.self) {
                            Text("\($0)")
                        }
                    }
                            .onChange(of: boat) { newValue in
                                boat = newValue
                                global.boat = selectedBoat(name: newValue)
                            }
                }

                Divider()

                Group {
                    Text("NMEA0183 TCP:").bold()
                    TextField("Host", text: $hostName).keyboardType(.alphabet)
                    TextField("Port", text: $port).keyboardType(.decimalPad)
                    Button("Connect") {
                        hideKeyboard()
                        if let p = Int(port) {
                            tcpNet = TcpNet(hostName: hostName, port: p)
                        }
                        UserDefaults.standard.set(hostName, forKey: "hostName")
                        UserDefaults.standard.set(port, forKey: "port")
                        tcpNet?.start()
                        record = true
                    }
                }

                HStack {
                    Circle().fill(color).frame(width: 15, height: 15, alignment: .center)
                    Text("invalid or no data")
                    Button("Record") {
                        tcpNet?.recording = true
                    }.disabled(!record)
                }

                Divider()

                Toggle("Use SOG for STW", isOn: $sog).onChange(of: sog) { value in
                    UserDefaults.standard.set(value, forKey: "sog4stw")
                }

                Spacer()

            }
        }.padding(padSzLg)
    }
}
