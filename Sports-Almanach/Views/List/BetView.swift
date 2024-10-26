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
    @EnvironmentObject var betViewModel: BetViewModel
    @State private var showBetSlip = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Text("Kontostand: \(userViewModel.balance, specifier: "%.2f") €")
                            .font(.title3)
                                                  .foregroundColor(.white)
                                                  .padding(.leading, 8)
                                                  .onReceive(userViewModel.$balance) { _ in
                                                      // Animation 
                                                  }
                        Spacer()
                        
                        Button("Wettschein") {
                            showBetSlip = true
                        }
                                             .font(.title3)
                                             .padding(.vertical, 4)
                                             .padding(.horizontal, 4)
                                             .foregroundColor(.white)
                                             .background(Color.orange)
                                             .cornerRadius(10)
                                             .overlay(
                                                 RoundedRectangle(cornerRadius: 10)
                                                     .stroke(Color.orange, lineWidth: 2)
                                             )
                                             .padding(.trailing, 8)
                                         }
                    .padding(.horizontal)
                    
                    List {
                        ForEach(eventViewModel.selectedBetEvents) { event in
                            BetRow(eventViewModel: eventViewModel, event: event)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) { // Swipe-Aktionen
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
            .sheet(isPresented: $showBetSlip) {
                 BetSlipView()
                     .presentationDetents([.large])
                     .environmentObject(userViewModel)
                     .environmentObject(eventViewModel) 
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
            .environmentObject(BetViewModel())
    }
