//
//  DateConverter.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 17.10.24.
//

import Foundation
import FirebaseCore

struct DateConverter {
    
    /// Rückgabe: Timestamp-Objekt, damit es in Firestore gespeichert werden kann
    static func convertDateToTimestamp(date: Date) -> Timestamp {
        return Timestamp(date: date)
    }
    
    /// Date-Objekt, um das Datum zu vergleichen, Benutzer Spielgeldbonus beim Gebutstag gutzuschreiben
    static func convertTimestampToDate(timestamp: Timestamp) -> Date {
        return timestamp.dateValue()
    }
}
