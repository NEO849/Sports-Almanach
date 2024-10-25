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
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Wettoptionen")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    List {
                        ForEach(eventViewModel.selectedBetEvents) { event in
                            BetRow(eventViewModel: eventViewModel, event: event)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) { // Swipe-Aktionen 
                                    Button(role: .destructive) {
                                        eventViewModel.removeFromBet(event) // Entfernen
                                    } label: {
                                        Label("Löschen", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    let eventViewModel = EventViewModel()
    eventViewModel.selectedBetEvents = MockEvents.events
    
    return BetView()
        .environmentObject(UserViewModel())
        .environmentObject(eventViewModel)
}
