//
//  ValidationUtils.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 19.11.24.
//

import Foundation

// MARK: Benutzereungaben-Überprüfugnen
struct ValidationUtils {
    static func validateRegistrationInputs(
        username: String,
        email: String,
        password: String,
        passwordRepeat: String,
        birthday: Date
    ) -> [UserError] {
        var errors: [UserError] = []
        
        if username.isEmpty || email.isEmpty || password.isEmpty || passwordRepeat.isEmpty {
            errors.append(UserError.userInputIsEmpty)
        }
        
        if password.containsWhitespace {
            errors.append(UserError.noSpace)
        }
        
        if !email.isValidEmail() {
            errors.append(UserError.invalidEmail)
        }
        
        if !password.isValidPassword() {
            errors.append(UserError.invalidPassword)
        }
        
        if password != passwordRepeat {
            errors.append(UserError.passwordMismatch)
        }
        
        if !BirthdayUtils.isOldEnough(birthday: birthday) {
            errors.append(UserError.tooYoung)
        }
        
        return errors
    }
}

// MARK: -
extension String {
    var containsWhitespace: Bool {
        return self.contains(" ")
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[A-Z])(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegEx).evaluate(with: self)
    }
}
