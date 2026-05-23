//
//  ContentView.swift
//  Sports-Almanach
//
//  Legacy entry point retained as a thin alias so older code paths still
//  compile while the move to MainTabView completes.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}
