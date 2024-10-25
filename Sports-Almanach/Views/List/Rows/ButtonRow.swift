//
//  ButtonRow.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 24.10.24.
//

import SwiftUI

struct ButtonRow: View {
    var action: () -> Void
    @ObservedObject var eventViewModel: EventViewModel
    var event: Event
    
    var body: some View {
        Button(action: action) {
            Text(eventViewModel.selectedBetEvents.contains(event) ? "---> Bereit zum Wetten <---" : "--->> Hinzufügen zur Wette <<---") // Text ändern
                .font(.subheadline)
                .foregroundColor(eventViewModel.selectedBetEvents.contains(event) ? .red : .blue) // Farbe ändern
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.orange, lineWidth: 2)
                        .frame(width: 300)
                )
        }
        .buttonStyle(.borderless)
    }
}

#Preview {
    ButtonRow(
        action: { print("Button gedrückt!") },
        eventViewModel: EventViewModel(),
        event: MockEvents.events.first!
    )
}
