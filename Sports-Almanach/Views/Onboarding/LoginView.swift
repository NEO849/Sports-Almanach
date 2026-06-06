//
//  LoginView.swift
//  Sports-Almanach
//
//  Re-implemented onboarding entry — uses semantic spacing, Dynamic Type,
//  and the shared AppBackground modifier. Routing back to the main app is
//  no longer this view's job — AppSession's auth stream flips RootView once
//  sign-in succeeds.
//

import SwiftUI

struct LoginView: View {

    @EnvironmentObject private var userVM: UserViewModel
    @FocusState private var focused: Field?

    @State private var email: String = ""
    @State private var password: String = ""

    private enum Field { case email, password }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.xl) {
                header
                    .padding(.top, AppTheme.Spacing.xxxl)

                inputs

                primaryAction

                registerLink

                socialDivider
                socials
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.bottom, AppTheme.Spacing.xxl)
        }
        .scrollDismissesKeyboard(.immediately)
        .appBackground(.gradient)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .alert("Fehler",
               isPresented: Binding(get: { userVM.alertMessage != nil }, set: { _ in userVM.clearAlert() })) {
            Button("OK", role: .cancel) { password = "" }
        } message: {
            Text(userVM.alertMessage ?? "")
        }
    }

    // MARK: - Sections

    private var header: some View {
        VStack(spacing: AppTheme.Spacing.m) {
            Image(systemName: "sportscourt.fill")
                .font(.system(size: 60))
                .foregroundStyle(AppTheme.Gradients.brand)
                .accentGlow(radius: 24, opacity: 0.6)
                .accessibilityHidden(true)
            VStack(spacing: AppTheme.Spacing.xxs) {
                Text("Sports Almanach")
                    .font(AppTheme.Typography.title3)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                Text("Anmelden")
                    .font(AppTheme.Typography.largeTitle)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var inputs: some View {
        VStack(spacing: AppTheme.Spacing.m) {
            InputField(
                title: "Email",
                placeholder: "name@beispiel.de",
                systemImage: "envelope",
                text: $email,
                contentType: .emailAddress,
                keyboard: .emailAddress
            )
            .focused($focused, equals: .email)
            .submitLabel(.next)
            .onSubmit { focused = .password }

            InputField(
                title: "Passwort",
                placeholder: "Mindestens 8 Zeichen",
                systemImage: "lock",
                text: $password,
                isSecure: true,
                contentType: .password
            )
            .focused($focused, equals: .password)
            .submitLabel(.go)
            .onSubmit { Task { await submit() } }
        }
    }

    private var primaryAction: some View {
        PrimaryActionButton(
            title: "Login",
            icon: "arrow.right.circle.fill",
            isEnabled: isFormValid,
            isLoading: userVM.isLoading,
            action: { Task { await submit() } }
        )
    }

    private var registerLink: some View {
        HStack(spacing: AppTheme.Spacing.xs) {
            Text("Noch keinen Account?")
                .foregroundStyle(AppTheme.Colors.textSecondary)
            NavigationLink {
                RegisterView()
            } label: {
                Text("Hier registrieren")
                    .fontWeight(.semibold)
                    .foregroundStyle(AppTheme.Colors.accentBright)
            }
        }
        .font(AppTheme.Typography.subheadline)
    }

    private var socialDivider: some View {
        HStack {
            line
            Text("oder")
                .font(AppTheme.Typography.footnote)
                .foregroundStyle(AppTheme.Colors.textTertiary)
                .padding(.horizontal, AppTheme.Spacing.s)
            line
        }
        .padding(.vertical, AppTheme.Spacing.s)
    }

    private var line: some View {
        Rectangle().fill(AppTheme.Colors.hairline).frame(height: 1)
    }

    private var socials: some View {
        HStack(spacing: AppTheme.Spacing.l) {
            SocialLoginButton(title: "Google", icon: "g.circle.fill", platform: .google) {
                // Google Sign-In will be wired up in a follow-up — kept as a
                // placeholder to preserve UI parity with the legacy design.
            }
            SocialLoginButton(title: "Facebook", icon: "f.circle.fill", platform: .facebook) {
                // Facebook Sign-In placeholder, see Google note.
            }
        }
    }

    // MARK: - Logic

    private var isFormValid: Bool {
        email.isValidEmail && !password.isEmpty
    }

    private func submit() async {
        focused = nil
        await userVM.login(email: email, password: password)
    }
}

#if DEBUG
#Preview("Login") {
    NavigationStack { LoginView() }.previewEnvironment()
}
#endif
