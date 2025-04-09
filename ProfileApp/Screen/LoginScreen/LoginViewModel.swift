//
//  LoginViewModel.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/8/25.
//

import Foundation
import SwiftUI

final class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var lastName = ""
    @Published var signUp = false
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "(?:[A-Z0-9a-z]+(?:[.-_][A-Z0-9a-z]+)*|\"(?:[^\"]|\\\\[\"])*\")@(?:[A-Z0-9a-z]+(?:[.-][A-Z0-9a-z]+)*|\\[(?:[0-9]{1,3}\\.){3}[0-9]{1,3}\\])"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
