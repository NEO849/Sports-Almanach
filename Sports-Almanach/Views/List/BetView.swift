//
//  BetView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct BetView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    @StateObject var betViewModel = BetViewModel()
    @State private var showBetSlip = false
    
    var body: some View {
        
        ZStack {
            Image("hintergrund")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack(alignment: .center) {
                    Text("Kontostand: \(userViewModel.balance, specifier: "%.2f") €")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                        .onReceive(userViewModel.$balance) { _ in
                            // Evtl Später Animation
                        }
                    Spacer()
                    
                    Button("Wettschein") {
                        showBetSlip = true
                    }
                    .font(.title3)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 2)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.orange, lineWidth: 1)
                    )
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
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) { // Swipe-Links
                                Button(role: .destructive) {
                                    // Wette Löschen
                                    betViewModel.bets.removeAll(where: { $0.event.id == event.id })
                                    betViewModel.updateTotalOdds()
                                    Task {
                                        await eventViewModel.deleteEventFromUserProfile(eventId: event.id)
                                    } // Event aus der Liste der ausgewählten Events
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
