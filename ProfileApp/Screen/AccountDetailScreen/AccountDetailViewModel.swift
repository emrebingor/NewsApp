//
//  AccountDetailViewModel.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/8/25.
//

import Foundation
import Firebase
import SwiftUI

final class AccountDetailViewModel: ObservableObject {
    
    @Published var firstName: String
    @Published var lastName: String
    @Published var email: String
    @Published var isLoading: Bool = false
    
    init(firstName: String, lastName: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    @MainActor
    func updateUser(uid: String) async {
        self.isLoading = true
        do {
            try await Firestore.firestore().collection("users").document(uid).setData(["name": self.firstName, "lastName": self.lastName, "email": self.email], merge: true)
            self.isLoading = false
        } catch {
            print("Error")
            self.isLoading = true
        }
    }
}
