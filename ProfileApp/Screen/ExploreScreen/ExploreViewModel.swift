//
//  ExploreViewModel.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/7/25.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import FirebaseAuth

final class ExploreViewModel: ObservableObject {
    
    @Published var userList: [User] = []
    @Published var selectedUser: User?
    @Published var userName: String = ""
    @Published var isDetailActive: Bool = false
    
    var filteredItems: [User] {
        if userName.isEmpty {
            return userList
        } else  {
            return userList.filter { $0.name.lowercased().contains(userName.lowercased()) }
        }
    }
    
    @MainActor
    func getSearchUser() {
        Task {
            self.userList.removeAll()
            do {
                let snapshot = try await Firestore.firestore().collection("users").getDocuments()
                
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let newsArray = data["news"] as? [[String: Any]] ?? []
                    let newsList: [News] = newsArray.compactMap { dict in
                        guard let title = dict["title"] as? String,
                              let id = dict["id"] as? String,
                              let likes = dict["likes"] as? Int,
                              let description = dict["description"] as? String else {
                            return nil
                        }
                        return News(title: title, id: id, description: description, likes: likes)
                    }
                    
                    let followersArray = data["followers"] as? [[String: Any]] ?? []
                    let followersList: [FollowInformation] = followersArray.compactMap { dict in
                        guard let name = dict["name"] as? String,
                              let lastName = dict["lastName"] as? String,
                              let id = dict["id"] as? String else {
                            return nil
                        }
                        return FollowInformation(name: name, lastName: lastName, id: id)
                    }
                    
                    let followingsArray = data["following"] as? [[String: Any]] ?? []
                    let followingsList: [FollowInformation] = followingsArray.compactMap { dict in
                        guard let name = dict["name"] as? String,
                              let lastName = dict["lastName"] as? String,
                              let id = dict["id"] as? String else {
                            return nil
                        }
                        return FollowInformation(name: name, lastName: lastName, id: id)
                    }
                    
                    let user = User(
                        id: document.documentID,
                        name: data["name"] as? String ?? "",
                        image: data["image"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        lastName: data["lastName"] as? String ?? "",
                        news: newsList,
                        followers: followersList,
                        following: followingsList,
                    )
                    
                    guard (Auth.auth().currentUser?.uid != user.id) else {
                        return
                    }
                    self.userList.append(user)
                }

            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
