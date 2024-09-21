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
        
        NavigationStack {
            ZStack {
                
                Image("splashsporthintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                // Liste der Events
                List(eventViewModel.events) { event in
                    Text(event.name)
                        .listRowBackground(Color.clear)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Events")
                .background(Color.clear)
            }
        }
    }
}

#Preview {
    EventsView()
        .environmentObject(EventViewModel())
}
