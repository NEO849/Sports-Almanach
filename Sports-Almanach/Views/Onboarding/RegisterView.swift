//
//  RegisterView.swift
//  Sports-Almanach
//

import SwiftUI

struct RegisterView: View {

    @EnvironmentObject private var userVM: UserViewModel
    @FocusState private var focused: Field?

    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var passwordRepeat = ""
    @State private var birthday: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()

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
        }
        .scrollDismissesKeyboard(.immediately)
        .appBackground(.photographic)
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
        VStack(spacing: AppTheme.Spacing.s) {
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: 56))
                .foregroundStyle(AppTheme.Colors.accent)
            Text("Registrieren")
                .font(AppTheme.Typography.largeTitle)
                .foregroundStyle(.white)
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
                .font(AppTheme.Typography.subheadline)
                .foregroundStyle(.white.opacity(0.85))
            HStack {
                Image(systemName: "calendar")
                    .foregroundStyle(AppTheme.Colors.accent)
                DatePicker("",
                           selection: $birthday,
                           in: ...Date(),
                           displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            .padding(AppTheme.Spacing.m)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.m, style: .continuous)
                    .strokeBorder(AppTheme.Colors.accent.opacity(0.6), lineWidth: 1)
            )
            Text("Mindestalter \(AppConstants.Validation.minimumAgeYears) Jahre.")
                .font(AppTheme.Typography.footnote)
                .foregroundStyle(.white.opacity(0.7))
        }
    }

    private var primaryAction: some View {
        PrimaryActionButton(
            title: "Registrieren",
            isEnabled: isFormValid,
            isLoading: userVM.isLoading,
            action: { Task { await submit() } }
        )
        .padding(.top, AppTheme.Spacing.s)
    }

    private var backToLogin: some View {
        NavigationLink {
            LoginView()
        } label: {
            Text("Zurück zur Anmeldung")
                .underline()
                .foregroundStyle(AppTheme.Colors.info)
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
