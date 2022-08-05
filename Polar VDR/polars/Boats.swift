//
// Created by William Kamp on 8/2/22.
//

import Foundation

struct Boat {
    let name: String
    let polar: PolarData
}

func selectedBoat(name: String? = nil) -> Boat {
    let n = name ?? UserDefaults.standard.string(forKey: "boat")
    return n.flatMap { name in
        boats.first { boat in
            boat.name == name
        }
    } ?? boats[0]
}

func saveSelectedBoat(name: String) {
    UserDefaults.standard.set(name, forKey: "boat")
}

let boatNames = boats.map { each in
    each.name
}

let boats = [
    Boat(name: "Tartan 37", polar: PolarData(csvLines: [
        "twa/tws;6;8;10;12;14;16;20",
        "0;0;0;0;0;0;0;0",
        "43.3;4.25;0;0;0;0;0;0",
        "41.5;0;4.97;0;0;0;0;0",
        "41.4;0;0;5.61;0;0;0;0",
        "41.2;0;0;0;6.09;0;0;0",
        "40.4;0;0;0;0;6.24;0;0",
        "39.9;0;0;0;0;0;6.31;0",
        "39.8;0;0;0;0;0;0;6.31",
        "52;4.74;5.6;6.3;6.65;6.83;6.9;6.94",
        "60;5.02;5.9;6.53;6.83;7;7.1;7.16",
        "75;5.22;6.15;6.69;6.98;7.17;7.33;7.52",
        "90;5.15;6.1;6.69;6.99;7.21;7.41;7.76",
        "110;4.64;5.62;6.45;6.88;7.15;7.4;7.9",
        "120;4.37;5.31;6.15;6.73;7.05;7.3;7.83",
        "135;3.8;4.78;5.56;6.29;6.76;7.05;7.54",
        "150;3.19;4.14;4.94;5.63;6.29;6.74;7.26",
        "167.5;2.84;0;0;0;0;0;0",
        "168;0;3.74;0;0;0;0;0",
        "169.2;0;0;4.53;0;0;0;0",
        "170.1;0;0;0;5.21;0;0;0",
        "170;0;0;0;0;5.87;0;0",
        "171.8;0;0;0;0;0;6.43;0",
        "175.4;0;0;0;0;0;0;7.05",
    ])!),
    Boat(name: "J/35", polar: PolarData(csvLines: [
        "twa/tws;6;8;10;12;14;16;20",
        "0;0;0;0;0;0;0;0",
        "42.6;4.96;0;0;0;0;0;0",
        "41.4;0;5.87;0;0;0;0;0",
        "39;0;0;6.37;0;0;0;0",
        "37.5;0;0;0;6.55;0;0;0",
        "36.4;0;0;0;0;6.62;0;0",
        "35.8;0;0;0;0;0;6.67;0",
        "35.4;0;0;0;0;0;0;6.71",
        "52;5.53;6.51;6.98;7.17;7.28;7.34;7.4",
        "60;5.84;6.72;7.11;7.34;7.47;7.56;7.65",
        "75;6.08;6.86;7.22;7.51;7.75;7.92;8.1",
        "90;5.99;6.84;7.24;7.55;7.87;8.16;8.56",
        "110;5.6;6.74;7.29;7.71;8.12;8.42;8.85",
        "120;5.45;6.61;7.21;7.66;8.13;8.58;9.31",
        "135;4.95;6.11;6.91;7.37;7.81;8.29;9.37",
        "150;4.18;5.28;6.26;6.95;7.37;7.78;8.68",
        "145.1;4.41;0;0;0;0;0;0",
        "149.3;0;5.31;0;0;0;0;0",
        "151.1;0;0;6.19;0;0;0;0",
        "157.8;0;0;0;6.64;0;0;0",
        "171.2;0;0;0;0;6.8;0;0",
        "177.2;0;0;0;0;0;7.18;0",
        "177.2;0;0;0;0;0;0;7.94",
    ])!)
]
