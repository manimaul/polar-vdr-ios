//
// Created by William Kamp on 7/27/22.
//

import Foundation
import SQLite

private func location() -> String {
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    return "\(path)/nmea.s3db"
}

class Records {
    let db: Connection?
    let nmea0183 = Table("nmea0183")
    let id = Expression<Int64>("id")
    let time = Expression<Int64>("time")
    let sentenceId = Expression<String>("sid")
    let sentenceData = Expression<String>("sdat")

    init() {
        do {
            db = try Connection(location())
            createTables()
        } catch {
            db = nil
        }
    }

    func insert(nmea: NmeaParts) {
        do {
            let record = nmea0183.insert(
                    time <- currentTimeMillis(),
                    sentenceId <- nmea.id,
                    sentenceData <- nmea.sentence
            )
            let rowId = try db?.run(record)
            print("inserted id: \(rowId)")
            print("sentence = \(nmea.sentence)")
        } catch {
            print("insert error: \(error)")
        }
    }

    func createTables() {
        do {
            try db?.run(nmea0183.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(time)
                t.column(sentenceId)
                t.column(sentenceData)
            })
        } catch {
            print("error: \(error)")
        }
    }

    func currentTimeMillis() -> Int64 {
        Int64(Date.now.timeIntervalSince1970 * 1000)
    }
}
