//
//  AppController.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/8/25.
//

import Foundation
import FirebaseAuth
import SwiftUI
import Firebase

enum AuthState {
    case undefined,
    authenticated,
    notAuthenticated
}

final class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isLoading: Bool = false
    
    func listenAuthChanges() {
        self.userSession = Auth.auth().currentUser
    }
    
    @MainActor
    func signUp(email: String, password: String, name: String, lastName: String) async throws {
        Task {
            self.isLoading = true
            do {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                self.userSession = result.user
                let user = User(
                    id: result.user.uid,
                    name: name,
                    image: "person.crop.circle.fill",
                    email: email,
                    lastName: lastName,
                    news: [],
                    followers: [],
                    following: [],
                )
                let encodedUser = try Firestore.Encoder().encode(user)
                try await Firestore.firestore().collection("users").document(result.user.uid).setData(encodedUser)
                await getUser()
                self.isLoading = false
            } catch {
                print("Error")
                self.isLoading = false
            }
        }
    }
    
    @MainActor
    func signIn(email: String, password: String) async throws {
        Task {
            self.isLoading = true
            do {
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                self.userSession = result.user
                await getUser()
                self.isLoading = false
            } catch {
                print(error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
            self.userSession = nil
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func deleteUser(uid: String) async throws {
        do {
            try await Firestore.firestore().collection("users").document(uid).delete()
            try await Auth.auth().currentUser?.delete()
            self.userSession = nil
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func getUser() async{
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Task {
            do {
                guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
                self.currentUser = try snapshot.data(as: User.self)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
