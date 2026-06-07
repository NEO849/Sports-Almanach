//
//  RegisterView.swift
//  Sports-Almanach
//

import SwiftUI

struct RegisterView: View {

    @EnvironmentObject private var userVM: UserViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focused: Field?

    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var passwordRepeat = ""
    // Neutral default (1 Jan, 25 years ago). NOT "today minus 25 years" — that
    // would land on today's day/month and hand every new tester the birthday
    // bonus on first login. Users pick their real date in the DatePicker.
    @State private var birthday: Date = {
        var components = DateComponents()
        components.year = Calendar.current.component(.year, from: Date()) - 25
        components.month = 1
        components.day = 1
        return Calendar.current.date(from: components) ?? Date()
    }()
    // Rein visueller Zustand für die Entrance-Animation (keine Logik).
    @State private var appeared = false

    private enum Field { case username, email, password, passwordRepeat }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.l) {
                header
                    .padding(.top, AppTheme.Spacing.xxl)

                inputs

                birthdayPicker

                primaryAction

                backToLogin
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
        .alert("Registrierung fehlgeschlagen",
               isPresented: Binding(get: { !userVM.formErrors.isEmpty || userVM.alertMessage != nil },
                                     set: { _ in userVM.clearAlert() })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessageBody)
        }
    }

    private var header: some View {
        VStack(spacing: AppTheme.Spacing.l) {
            // Kantiger, dunkler "Tech-Chip" — konsistent zur LoginView.
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous)
                    .fill(AppTheme.Colors.surfaceSecondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.l, style: .continuous)
                            .strokeBorder(AppTheme.Colors.strokeSubtle, lineWidth: 1)
                    )
                    .frame(width: 78, height: 78)
                Image(systemName: "person.crop.circle.badge.plus")
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
                Text("Registrieren")
                    .font(AppTheme.Typography.largeTitle)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var inputs: some View {
        VStack(spacing: AppTheme.Spacing.m) {
            InputField(title: "Benutzername",
                       placeholder: "Wie soll man dich nennen?",
                       systemImage: "person",
                       text: $username,
                       contentType: .nickname)
                .focused($focused, equals: .username)
                .submitLabel(.next)
                .onSubmit { focused = .email }

            InputField(title: "Email",
                       placeholder: "name@beispiel.de",
                       systemImage: "envelope",
                       text: $email,
                       contentType: .emailAddress,
                       keyboard: .emailAddress)
                .focused($focused, equals: .email)
                .submitLabel(.next)
                .onSubmit { focused = .password }

            InputField(title: "Passwort",
                       placeholder: "Mindestens 8 Zeichen",
                       systemImage: "lock",
                       text: $password,
                       isSecure: true,
                       contentType: .newPassword)
                .focused($focused, equals: .password)
                .submitLabel(.next)
                .onSubmit { focused = .passwordRepeat }

            InputField(title: "Passwort wiederholen",
                       placeholder: "Zur Bestätigung",
                       systemImage: "lock.shield",
                       text: $passwordRepeat,
                       isSecure: true,
                       contentType: .newPassword)
                .focused($focused, equals: .passwordRepeat)
                .submitLabel(.go)
                .onSubmit { Task { await submit() } }
        }
    }

    private var birthdayPicker: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text("Geburtsdatum")
                .font(AppTheme.Typography.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.Colors.textSecondary)
            HStack {
                Image(systemName: "calendar")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.accent)
                    .frame(width: 22)
                DatePicker("",
                           selection: $birthday,
                           in: ...Date(),
                           displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .tint(AppTheme.Colors.accent)
            }
            .padding(AppTheme.Spacing.m)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                    .strokeBorder(AppTheme.Colors.strokeSubtle, lineWidth: 1)
            )
            Text("Mindestalter \(AppConstants.Validation.minimumAgeYears) Jahre.")
                .font(AppTheme.Typography.footnote)
                .foregroundStyle(AppTheme.Colors.textTertiary)
        }
    }

    private var primaryAction: some View {
        PrimaryActionButton(
            title: "Registrieren",
            icon: "checkmark.circle.fill",
            isEnabled: isFormValid,
            isLoading: userVM.isLoading,
            action: { Task { await submit() } }
        )
        .padding(.top, AppTheme.Spacing.s)
    }

    private var backToLogin: some View {
        Button {
            dismiss()
        } label: {
            Text("Zurück zur Anmeldung")
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.Colors.accentBright)
        }
        .font(AppTheme.Typography.subheadline)
    }

    private var isFormValid: Bool {
        !username.isEmpty && email.isValidEmail && password.isValidPassword && password == passwordRepeat
    }

    private var errorMessageBody: String {
        if let alert = userVM.alertMessage, !alert.isEmpty { return alert }
        return userVM.formErrors
            .compactMap { $0.errorDescriptionGerman }
            .joined(separator: "\n")
    }

    private func submit() async {
        focused = nil
        await userVM.register(
            username: username.trimmingCharacters(in: .whitespaces),
            email: email.trimmingCharacters(in: .whitespaces),
            password: password,
            passwordRepeat: passwordRepeat,
            birthday: birthday
        )
    }
}

#if DEBUG
#Preview("Register") {
    NavigationStack { RegisterView() }.previewEnvironment()
}
#endif
