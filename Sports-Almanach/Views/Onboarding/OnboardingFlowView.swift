//
//  OnboardingFlowView.swift
//  Sports-Almanach
//
//  Hosts the Login → Register navigation, isolated from RootView so the
//  authentication flow is the only thing here.
//

import SwiftUI

struct OnboardingFlowView: View {
    var body: some View {
        NavigationStack {
            LoginView()
        }
    }
}

#if DEBUG
#Preview("Onboarding") {
    OnboardingFlowView().previewEnvironment()
}
#endif
