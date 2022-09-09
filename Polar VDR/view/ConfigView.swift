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

struct ConfigView: View {
    @EnvironmentObject var global: Global
    @EnvironmentObject var tcpState: TcpState

    @State var hostName: String = globalTcpState.host ?? ""
    @State var port: String = globalTcpState.port ?? ""
    @State var sog: Bool = globalState.sog

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
                    }.onChange(of: boat) { newValue in
                        boat = newValue
                        global.boat = selectedBoat(name: newValue)
                    }
                }

                Divider()

                Group {
                    Text("NMEA0183 TCP:").bold()
                    TextField("Host", text: $hostName).keyboardType(.alphabet)
                    TextField("Port", text: $port).keyboardType(.decimalPad)
                    Button("Save") {
                        hideKeyboard()
                        tcpState.host = hostName
                        tcpState.port = port
                        UserDefaults.standard.set(hostName, forKey: "hostName")
                        UserDefaults.standard.set(port, forKey: "port")
                        globalTcp.stop()
                    }
                }

                HStack {
                    Circle().fill(tcpState.color).frame(width: 15, height: 15, alignment: .center)
                    Text(tcpState.status)
//                    Button("Record") {
//                        tcpState.recording = !tcpState.recording
//                    }.disabled(!tcpState.validData)
                }

                Divider()

                Toggle("Use SOG for STW", isOn: $sog).onChange(of: sog) { value in
                    UserDefaults.standard.set(value, forKey: "sog4stw")
                    global.sog = value
                }

                Spacer()

            }
        }.padding(padSzLg)
    }
}
