//
//  Validator.swift
//  iOSFinalProject
//
//  Created by Blend Mustafa on 4/13/25.
//

import Foundation

class Validator {
    static func isValidEmail(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
}
