//
//  ExploreViewModel.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/7/25.
//

import Foundation
import FirebaseFirestore
import SwiftUI

final class ExploreViewModel: ObservableObject {
    
    @Published var userList: [User] = []
    @Published var selectedUser: User?
    @Published var userName: String = ""
    @Published var isDetailActive: Bool = false
    
    @MainActor
    func getSearchUser() {
        Task {
            self.userList.removeAll()
            do {
                let snapshot = try await Firestore.firestore().collection("users").getDocuments()
                
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let user = User(
                        id: document.documentID,
                        name: data["name"] as? String ?? "",
                        image: data["image"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        lastName: data["lastName"] as? String ?? "",
                        news: data["news"] as? [News] ?? [],
                        followers: data["followers"] as? Int ?? 0,
                        following: data["following"] as? Int ?? 0,
                    )
                    
                    self.userList.append(user)
                }

            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
