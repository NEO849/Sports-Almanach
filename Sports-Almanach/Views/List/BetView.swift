//
//  BetView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct BetView: View {
    
    /// Global, Lokal, UI State
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    @StateObject private var betViewModel = BetViewModel()
    @State private var showBetSlip = false
    
    var body: some View {
        ZStack {
            Image("hintergrund")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                // Kontostand und Wettschein Button
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
                .padding(.horizontal, 22)
                
                // MARK: - Liste der ausgewählten Events
                List {
                    ForEach(eventViewModel.selectedEvents) { event in
                        BetRow(event: event)
                            .environmentObject(betViewModel)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    // Einzelnes Event löschen
                                    eventViewModel.syncDeleteEvent(event)
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
        .onAppear {
            betViewModel.setViewModels(user: userViewModel, event: eventViewModel)
        }
        .onDisappear {
            // Tasks canceln beim Verlassen der View
            eventViewModel.cancelLoadingTasks()
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
