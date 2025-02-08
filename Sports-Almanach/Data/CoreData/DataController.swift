//
//  DataController.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 08.02.25.
//

import Foundation
import CoreData
import Combine

class DataController: ObservableObject {
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "CoreModel")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data: \(error)")
            }
        }
    }

    func saveBet(bet: Bet) {
        let selectedBet = SelectedBet.init(context: container.viewContext)
        selectedBet.id = bet.id
        selectedBet.eventId = bet.event.id
        selectedBet.betOutcome = bet.outcome.rawValue
        selectedBet.odds = bet.odds
        selectedBet.betAmount = bet.betAmount

        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save Bet: \(error)")
        }
    }

    // Method to fetch bets
    func fetchBets() -> [SelectedBet] {
        let request: NSFetchRequest<SelectedBet> = SelectedBet.fetchRequest()
        let selectedBets = (try? container.viewContext.fetch(request)) ?? []
        return selectedBets
    }
}
