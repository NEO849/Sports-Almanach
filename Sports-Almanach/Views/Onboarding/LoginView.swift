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
    @State private var showRegister = false

    @State private var email: String = ""
    @State private var password: String = ""
    // Rein visueller Zustand für die Entrance-Animation (keine Logik).
    @State private var appeared = false

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
            // Ruhige Entrance: leichtes Auf-/Einblenden, kein Bouncen.
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 14)
        }
        .scrollDismissesKeyboard(.immediately)
        .appBackground(.gradient)
        .onAppear { withAnimation(.easeOut(duration: 0.45)) { appeared = true } }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showRegister) {
            RegisterView()
        }
        .alert("Fehler",
               isPresented: Binding(get: { userVM.alertMessage != nil }, set: { _ in userVM.clearAlert() })) {
            Button("OK", role: .cancel) { password = "" }
        } message: {
            Text(userVM.alertMessage ?? "")
        }
    }

    // MARK: - Sections

    private var header: some View {
        VStack(spacing: AppTheme.Spacing.l) {
            // Kantiger, dunkler "Tech-Chip" — Orange nur als gezielter Akzent,
            // keine große Leuchtfläche.
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous)
                    .fill(AppTheme.Colors.surfaceSecondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous)
                            .strokeBorder(AppTheme.Colors.strokeSubtle, lineWidth: 1)
                    )
                    .frame(width: 78, height: 78)
                Image(systemName: "sportscourt.fill")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.accent)
                    .symbolEffect(.bounce, value: appeared)
            }
            .accentGlow(radius: 16, opacity: 0.25)
            .accessibilityHidden(true)

            VStack(spacing: AppTheme.Spacing.xs) {
                Text("SPORTS ALMANACH")
                    .font(AppTheme.Typography.caption.weight(.semibold))
                    .kerning(2.5)
                    .foregroundStyle(AppTheme.Colors.textTertiary)
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
            Button {
                showRegister = true
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
