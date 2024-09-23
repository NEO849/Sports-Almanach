//
//  SplashViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 21.09.24.
//

import SwiftUI

// Steuert die Logik des SplashScreens
class SplashViewModel: ObservableObject {
    @Published var showLoginView = false

    init() {
        simulateLoading()
    }

    private func simulateLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showLoginView = true
        }
    }
}
