//
//  BirthdayChecker.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 16.10.24.
//

import Foundation
import FirebaseFirestore
import SwiftUI            // Wegen Timestamp

struct BirthdayChecker {
    
    /// Ob der Benutzer heute Geburtstag hat
    static func checkBirthday(userId: String, birthday: Timestamp) {
        let today = Date()
        let birthdayDate = birthday.dateValue()
        
        if Calendar.current.isDate(today, inSameDayAs: birthdayDate) {
            // Geburtstag! Bonus gutschreiben
            grantBirthdayBonus(userId: userId)
        }
    }
    
    /// Gewährt dem Benutzer den Geburtstagsbonus
    static private func grantBirthdayBonus(userId: String) {
        let bonus = 2500.00 // Geburtstagsbonus
        let datab = Firestore.firestore()
        let userRef = datab.collection("Profile").document(userId) // Referenz aufs Benutzerdokument in Firestore
        
        // FB Transaktion, um den Bonus gutzuschreiben
        datab.runTransaction { transaction, errorPointer in
            do {
                let userDocument: DocumentSnapshot = try transaction.getDocument(userRef) // Aktuelle Daten auslesen
                
                // Kontostand auslesen
                guard let currentBalance = userDocument.get("startMoney") as? Double else {
                    let error = NSError(domain: "BirthdayBonusError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fehler beim Spielgeldstand."])
                    errorPointer?.pointee = error
                    return nil
                }
                
                let newBalance = currentBalance + bonus // Neuen Kontostand berechnen
                transaction.updateData(["startMoney": newBalance], forDocument: userRef) // Kontostand aktua.
                return newBalance
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
        } completion: { object, error in
            if let error = error {
                print("Fehler beim Gutschreiben des Geburtstagsbonus: \(error)")
            } else if let newBalance = object as? Double {
                print("Geburtstagsbonus gutgeschrieben. Neuer Kontostand: \(newBalance)")
            }
        }
    }
    
    /// Tägliche Überprüfung des Geburtstags im UserVM
    static func scheduleBirthdayCheck(for viewModel: UserViewModel) {
        let calendar = Calendar.current
        let now = Date()
        
        // Uhrzeit für Überprüfung (00:01)
        let checkTimeComponents = DateComponents(hour: 0, minute: 1)
        let nextCheckTime = calendar.nextDate(after: now, matching: checkTimeComponents, matchingPolicy: .nextTime)!
        
        // Timer der täglich zur angegebenen Zeit den Closure ausführt
        let timer = Timer(fire: nextCheckTime, interval: 86400, repeats: true) { _ in
            Task { @MainActor in // Asynchroner Task auf dem Main Actor
                viewModel.checkUserBirthday()
            }
        }
        RunLoop.main.add(timer, forMode: .common)
    }
}
