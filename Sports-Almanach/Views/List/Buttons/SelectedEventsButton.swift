//
//  SelectedEventsButton.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 04.11.24.
//

import SwiftUI

struct SelectedEventsButton: View {
    var action: () -> Void
    @ObservedObject var eventViewModel: EventViewModel
    var event: Event
    
    var body: some View {
        Button(action: action) {
            /// A-Synchronér "call" nicht gleichzeitig möglich
            Text(eventViewModel.selectedEvents.contains(event) ? "--->>   Zum Entfernen Swipe   <<---" : "--->>  Hinzufügen zu Wett-Events  <<---")
                .font(.subheadline)
                .foregroundColor(eventViewModel.selectedEvents.contains(event) ? .green : .blue)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.orange, lineWidth: 1)
                )
        }
        .buttonStyle(.borderless)
    }
}
