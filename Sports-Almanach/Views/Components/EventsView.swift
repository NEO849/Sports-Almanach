//
//  EventsView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI


struct EventsView: View {
    @EnvironmentObject var eventViewModel: EventViewModel

    var body: some View {
        List(eventViewModel.events) { event in
            Text(event.name) //  Eventnamen
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Events") 
    }
}
