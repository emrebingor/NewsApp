//
//  UserDetailViewModel.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/9/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

final class UserDetailViewModel: ObservableObject {
    
    @Published var user: User
    @Published var currentUser: User
    var isDetailActive: Binding<Bool>
    @Published var isNewsDetailActive = false
    @Published var selectedNews: News?
    
    init(user: User, currentUser: User, isDetailActive: Binding<Bool>) {
        self.user = user
        self.currentUser = currentUser
        self.isDetailActive = isDetailActive
    }
    
    @MainActor
    func updateFollowNumber() async{
        guard !currentUser.following.contains(where: { $0.id == user.id}) else {
            print("Already followed")
            return
        }
        
        self.user.followers.append(FollowInformation(name: currentUser.name, lastName: currentUser.lastName, id: currentUser.id))
        let newFollowersDictionary = user.followers.map {["name": $0.name, "lastName": $0.lastName, "id": $0.id]}
        
        self.currentUser.following.append(FollowInformation(name: user.name, lastName: user.lastName, id: user.id))
        let newFollowingsDictionary = currentUser.following.map {["name": $0.name, "lastName": $0.lastName, "id": $0.id]}
        
        do {
            try await Firestore.firestore().collection("users").document(user.id).updateData(["followers": newFollowersDictionary])
            try await Firestore.firestore().collection("users").document(currentUser.id).updateData(["following": newFollowingsDictionary])
        } catch {
            print(error.localizedDescription)
        }
    }
}
