//
//  BirthdayUtils.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 19.11.24.
//

import Foundation
import FirebaseFirestore

/// Hilfsklasse für alle Geburtstags- und Altersoperationen
struct BirthdayUtils {
    
    static func checkBirthday(userId: String, birthday: Timestamp) {
        let today = Date()
        let birthdayDateUser = birthday.dateValue()
        
        // Ist heute Geburtstag?
        if Calendar.current.isDate(today, inSameDayAs: birthdayDateUser) {
            grantBirthdayBonus(userId: userId)
        }
    }
    
    // Bonus in Firestore gutschreiben, Referenz für das Benutzerdokument
    private static func grantBirthdayBonus(userId: String) {
        let bonus = 2500.00
        let datab = Firestore.firestore()
        let userRef = datab.collection("Profile").document(userId)
        
        // Transaktion und auslesen
        datab.runTransaction { transaction, errorPointer in
            do {
                let userDocument: DocumentSnapshot = try transaction.getDocument(userRef)
                
                // Aktuellen Kontostand auslesen
                guard let currentBalance = userDocument.get("startMoney") as? Double else {
                    let error = NSError(domain: "BirthdayBonusError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fehler beim Spielgeldstand."])
                    errorPointer?.pointee = error
                    return nil
                }
                
                // Neuen Kontostand berechnen und aktualisieren
                let newBalance = currentBalance + bonus
                transaction.updateData(["balance": newBalance], forDocument: userRef)
                return newBalance
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
        } completion: { object, error in
            // Abschluss der Transaktion
            if let error = error {
                print("Fehler beim Gutschreiben des Geburtstagsbonus: \(error)")
            } else if let newBalance = object as? Double {
                print("Geburtstagsbonus erfolgreich gutgeschrieben. Neuer Kontostand: \(newBalance)")
            }
        }
    }
    
    // Plant die tägliche Überprüfung des Geburtstags
    static func dailyBirthdayCheck(for viewModel: UserViewModel) {
        let calendar = Calendar.current
        let now = Date()
        
        // Überprüfungszeitpunkt (00:01 Uhr) festlegen ud Timer planen
        let checkTimeComponents = DateComponents(hour: 0, minute: 1)
        let nextCheckTime = calendar.nextDate(after: now, matching: checkTimeComponents, matchingPolicy: .nextTime)!
        
        Timer.scheduledTimer(withTimeInterval: nextCheckTime.timeIntervalSince(now), repeats: true) { _ in
            Task { @MainActor in
                viewModel.checkUserBirthday()
            }
        }
    }
    
    // Berechnet das Alter und ob er mindestens 18 Jahre alt ist
    static func isOldEnough(birthday: Date) -> Bool {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
        return (ageComponents.year ?? 0) >= 18
    }
}
