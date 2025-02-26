//
//  ValidationUtils.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 19.11.24.
//

import Foundation

// MARK: - Benutzereingaben-Validierung
/// Provides methods to validate user inputs using the unified AppErrors system for structured error handling.
struct ValidationUtils {

    /// - Checks for empty fields, whitespace, email format, password strength, password matching, and age verification
    /// - Returns an empty list if no errors were found
    static func validateRegistrationInputs(
        username: String,
        email: String,
        password: String,
        passwordRepeat: String,
        birthday: Date
    ) -> [AppErrors.User] {
        var errors: [AppErrors.User] = []
        
        // Checks if all required fields are filled
        if username.isEmpty || email.isEmpty || password.isEmpty || passwordRepeat.isEmpty {
            errors.append(AppErrors.User.userInputIsEmpty)
        }
        
        // Checks for spaces in password (security measure)
        if password.contains(" ") {
            errors.append(AppErrors.User.noSpace)
        }
        
        // Validates email format using regex (defined in String extension)
        if !email.isValidEmail {
            errors.append(AppErrors.User.invalidEmail)
        }
        
        // Checks password strength (min 8 chars, numbers, upper/lowercase, special chars)
        if !password.isValidPassword {
            errors.append(AppErrors.User.invalidPassword)
        }
        
        // Ensures both entered passwords match
        if password != passwordRepeat {
            errors.append(AppErrors.User.passwordMismatch)
        }
        
        // Verifies user is old enough (18+, implemented in BirthdayUtils)
        if !BirthdayUtils.isOldEnough(birthday: birthday) {
            errors.append(AppErrors.User.tooYoung)
        }
        
        return errors
    }
}

// MARK: - String-Validierungshilfen
/// Enables clean, readable syntax when validating
extension String {
    /// Checks if the string contains whitespace
    var containsWhitespace: Bool {
        return self.contains(" ")
    }
    
    /// Checks if the string starts with whitespace
    var hasLeadingWhitespace: Bool {
        return self.hasPrefix(" ")
    }

    /// Validates if the string has a valid email format
    /// - Uses a regular expression for verification
    /// - Performance-optimized using NSPredicate instead of complex string processing
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: self)
    }

    /// Validates if the password meets security requirements:
    /// - At least 8 characters long
    /// - Contains at least one letter and one digit
    /// - Contains at least one uppercase letter
    /// - Contains at least one special character (@$!%*?&)
    var isValidPassword: Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[A-Z])(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegEx).evaluate(with: self)
    }
}
