//
//  ValidationUtils.swift
//  Sports-Almanach
//
//  Registration-input validation. Same surface as the legacy file; minimum
//  age comes from AppConstants and a couple of regex literals are tightened.
//

import Foundation

public enum ValidationUtils {

    public static func validateRegistrationInputs(username: String,
                                                  email: String,
                                                  password: String,
                                                  passwordRepeat: String,
                                                  birthday: Date) -> [AppErrors.User] {
        var errors: [AppErrors.User] = []

        if username.trimmingCharacters(in: .whitespaces).isEmpty
            || email.trimmingCharacters(in: .whitespaces).isEmpty
            || password.isEmpty
            || passwordRepeat.isEmpty {
            errors.append(.userInputIsEmpty)
        }

        if password.contains(" ") || username.hasPrefix(" ") {
            errors.append(.noSpace)
        }

        if !email.isValidEmail {
            errors.append(.invalidEmail)
        }

        if !password.isValidPassword {
            errors.append(.invalidPassword)
        }

        if password != passwordRepeat {
            errors.append(.passwordMismatch)
        }

        if !isOldEnough(birthday: birthday) {
            errors.append(.tooYoung)
        }

        return errors
    }

    public static func isOldEnough(birthday: Date) -> Bool {
        let years = Calendar.current.dateComponents([.year], from: birthday, to: Date()).year ?? 0
        return years >= AppConstants.Validation.minimumAgeYears
    }
}

public extension String {
    var isValidEmail: Bool {
        // RFC 5322-ish, simple but practical.
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }

    /// 8+ chars, mixed case, digit, and one of @$!%*?&
    var isValidPassword: Bool {
        let pattern = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
}
