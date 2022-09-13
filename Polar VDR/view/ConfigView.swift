//
//  Config.swift
//  Polar VDR
//
//  Created by William Kamp on 7/24/22.
//

import SwiftUI

//var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

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
    @FocusState private var isFocused: Bool

    @State private var boat: String = selectedBoat().name

    var body: some View {
        VStack {
            Text("Settings").fontWeight(.heavy)
            Form {
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

                Text("NMEA0183 TCP:").bold()
                TextField("Host", text: $hostName)
                        .disableAutocorrection(true)
                        .keyboardType(.alphabet)
                        .onChange(of: hostName) { value in
                    tcpState.hostChange(value)
                }.focused($isFocused)

                TextField("Port", text: $port)
                        .disableAutocorrection(true)
                        .keyboardType(.decimalPad)
                        .onChange(of: port) { value in
                    tcpState.portChange(value)
                }.focused($isFocused)

                Toggle("Use SOG for STW", isOn: $sog).onChange(of: sog) { value in
                    UserDefaults.standard.set(value, forKey: "sog4stw")
                    global.sog = value
                }
            }.toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        isFocused = false
                    }
                }
            }

            HStack {
                Circle().fill(tcpState.color).frame(width: 15, height: 15, alignment: .center)
                Text(tcpState.status)
            }

        }.padding(padSzLg)
    }
}
