//
//  ValidationUtilsTests.swift
//  Sports-AlmanachTests
//

import XCTest
@testable import Sports_Almanach

final class ValidationUtilsTests: XCTestCase {

    func test_validEmail() {
        XCTAssertTrue("user@example.com".isValidEmail)
        XCTAssertTrue("user.name+tag@sub.example.co.uk".isValidEmail)
    }

    func test_invalidEmail() {
        XCTAssertFalse("no-at-sign".isValidEmail)
        XCTAssertFalse("user@".isValidEmail)
        XCTAssertFalse("@example.com".isValidEmail)
    }

    func test_validPassword() {
        XCTAssertTrue("Abcd1234!".isValidPassword)
        XCTAssertTrue("Pa55word@".isValidPassword)
    }

    func test_invalidPassword() {
        XCTAssertFalse("abcd1234".isValidPassword)       // no upper/special
        XCTAssertFalse("ABCD1234".isValidPassword)       // no lower/special
        XCTAssertFalse("Abcdefg!".isValidPassword)       // no digit
        XCTAssertFalse("Ab1!".isValidPassword)           // too short
    }

    func test_registration_validInputs_returnsNoErrors() {
        let birthday = Calendar.current.date(byAdding: .year, value: -25, to: Date())!
        let errors = ValidationUtils.validateRegistrationInputs(
            username: "Tom",
            email: "tom@example.com",
            password: "Tom-Password1!",
            passwordRepeat: "Tom-Password1!",
            birthday: birthday
        )
        XCTAssertTrue(errors.isEmpty)
    }

    func test_registration_collectsMultipleErrors() {
        let tooYoung = Calendar.current.date(byAdding: .year, value: -10, to: Date())!
        let errors = ValidationUtils.validateRegistrationInputs(
            username: "",
            email: "bad-email",
            password: "weak",
            passwordRepeat: "different",
            birthday: tooYoung
        )
        XCTAssertTrue(errors.contains(.userInputIsEmpty))
        XCTAssertTrue(errors.contains(.invalidEmail))
        XCTAssertTrue(errors.contains(.invalidPassword))
        XCTAssertTrue(errors.contains(.passwordMismatch))
        XCTAssertTrue(errors.contains(.tooYoung))
    }
}
