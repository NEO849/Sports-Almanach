//
//  BetRow.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 23.10.24.
//

import SwiftUI

struct BetRow: View {
    
    @ObservedObject var eventViewModel: EventViewModel
    let event: Event
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(event.name)
                .font(.headline)
            HStack {
                Text("\(eventViewModel.formattedDate(for: event)) um \(eventViewModel.formattedTime(for: event))")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
            OddsRow(event: event)
        }
    }
}

#Preview {
    let mockEvent = MockEvents.events.first!
    BetRow(eventViewModel: EventViewModel(), event: mockEvent)
}
