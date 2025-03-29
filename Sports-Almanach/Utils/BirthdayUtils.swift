//
//  BirthdayUtils.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 19.11.24.
//

import Foundation
import FirebaseFirestore

/// Verwaltung von Geburtstags-Boni
struct BirthdayUtils {
    /// Konstanten für die Geburtstagsbonus-Logik
    private enum Constants {
        static let birthdayBonus: Double = 2500.0
        /// Überprüfungszeit (06:00 Uhr)
        static let checkHour: Int = 6
        static let checkMinute: Int = 0
    }
    
    /// Speichert den letzten Überprüfungstag
    private static var lastCheckDate: Date?
    
    /// Plant die tägliche Überprüfung des Geburtstags um 06:00 Uhr
    static func scheduleDailyBirthdayCheck(for viewModel: UserViewModel) {
        let calendar = Calendar.current
        let now = Date()
        
        // Nächsten Überprüfungszeitpunkt berechnen (06:00 Uhr)
        var components = DateComponents()
        components.hour = Constants.checkHour
        components.minute = Constants.checkMinute
        
        guard let nextCheck = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime) else {
            print("❌ Fehler beim Berechnen des nächsten Überprüfungszeitpunkts")
            return
        }
        
        let interval = nextCheck.timeIntervalSince(now)
        print("🕐 Geburtstags-Check geplant für: \(nextCheck)")
        
        // Einmaliger Timer für die nächste Überprüfung am nächsten Tag
        Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            Task { @MainActor in
                await checkAndGrantBirthdayBonus(for: viewModel)
                scheduleDailyBirthdayCheck(for: viewModel)
            }
        }
        
        // Sofortige erste Überprüfung
        Task { @MainActor in
            await checkAndGrantBirthdayBonus(for: viewModel)
        }
        
        print("✅ Geburtstags-Check geplant für: \(nextCheck)")
    }
    
    /// Überprüft und vergibt den Geburtstagsbonus
    private static func checkAndGrantBirthdayBonus(for viewModel: UserViewModel) async {
        let today = Date()
        
        // Prüft ob heute schon überprüft wurde
        if let lastCheck = lastCheckDate,
           Calendar.current.isDate(lastCheck, inSameDayAs: today) {
            return
        }
        
        // Aktualisiere letzten Überprüfungstag
        lastCheckDate = today
        
        guard FirebaseAuthManager.shared.userID != nil,
              let birthdayTimestamp = await viewModel.userState.birthday else {
            print("❌ Keine Benutzer-ID oder Geburtstag gefunden")
            await viewModel.loadUserProfile()
            return
        }
        
        let birthday = birthdayTimestamp.dateValue()
        let calendar = Calendar.current
        
        print("📅 Vergleiche Datum - Geburtstag: \(birthday), Heute: \(today)")
        
        // Überprüfe ob heute Geburtstag ist
        let isBirthday = calendar.isDate(today, equalTo: birthday, toGranularity: .day) &&
                        calendar.isDate(today, equalTo: birthday, toGranularity: .month)
        
        if isBirthday {
            print("🎉 Heute ist Geburtstag! Schreibe Bonus gut...")
            await viewModel.updateBalance(amount: Constants.birthdayBonus, type: .birthdayBonus)
            print("💰 Geburtstagsbonus von \(Constants.birthdayBonus)€ gutgeschrieben")
        } else {
            print("📝 Heute kein Geburtstag")
        }
    }
    
    /// Überprüft ob ein Benutzer mindestens 18 Jahre alt ist
    static func isOldEnough(birthday: Date) -> Bool {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
        return (ageComponents.year ?? 0) >= 18
    }
}
