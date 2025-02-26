//
//  BetView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct BetView: View {
    
    /// Globale Daten
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    /// Lokale Daten
    @StateObject var betViewModel = BetViewModel()
    /// Status für Sheet
    @State private var showBetSlip = false
    
    var body: some View {
        
        ZStack {
            Image("hintergrund")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack(alignment: .center) {
                    Text("Kontostand: \(userViewModel.userState.balance, specifier: "%.2f") €")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                        .animation(.easeInOut, value: userViewModel.userState.balance)

                    Spacer()
                    
                    Button("Wettschein") {
                        showBetSlip = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .padding(.trailing, 8)
                }
                .padding(.horizontal)
                .padding(.top, 60)
                
                List {
                    ForEach(eventViewModel.selectedEvents) { event in
                        BetRow(eventViewModel: eventViewModel, event: event)
                            .environmentObject(betViewModel)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) { 
                                Button(role: .destructive) {
                                    // Zuerst aus den ausgewählten Events entfernen
                                    eventViewModel.removeFromSelectedEvents(event) 
                                    // Dann aus den Wetten entfernen
                                    betViewModel.bets.removeAll(where: { $0.event.id == event.id })
                                    // Quoten aktualisieren
                                    betViewModel.updateTotalOdds()
                                    Task {
                                        await eventViewModel.deleteEventFromUserProfile(eventId: event.id)
                                    } 
                                } label: {
                                    Label("Löschen", systemImage: "trash")
                                }
                            }
                    }
                }
                .listStyle(.plain)
            }
        }
        .sheet(isPresented: $showBetSlip) {
            BetSlipView()
                .presentationDetents([.large])
                .environmentObject(userViewModel)
                .environmentObject(eventViewModel)
                .environmentObject(betViewModel)
        }
    }
}

#Preview {
    let eventViewModel = EventViewModel()
    eventViewModel.selectedEvents = MockEvents.events
    return BetView()
        .environmentObject(UserViewModel())
        .environmentObject(eventViewModel)
}
