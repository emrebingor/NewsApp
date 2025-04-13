//
//  ProfileViewModel.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/7/25.
//

import Foundation
import FirebaseFirestore
import _PhotosUI_SwiftUI
import FirebaseAuth
import SwiftUICore
import SwiftUI

final class ProfileViewModel: ObservableObject {
    
    @Published var user: User = User(id: "", name: "", image: "", email: "", lastName: "", news: [], followers: [], following: [])
    @Published var imageSelection: PhotosPickerItem? = nil
    @Published var selectedImage: UIImage? = nil
    @Published var selectedNews: News?
    @Published var isLoading: Bool = false
    @Published var isDetailActive: Bool = false
    @Published var newsTitle: String = ""
    @Published var newsDescription: String = ""
    
    @MainActor
    func setImage(data selection: PhotosPickerItem?) {
        guard let selection = selection else { return }

        Task {
            if let data = try? await selection.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                self.selectedImage = uiImage
            }
        }
    }
    
    @MainActor
    func addNews() {
        self.user.news.append(News(title: newsTitle, id: UUID().uuidString, description: newsDescription, likes: 0))
        
        let newsDicts = self.user.news.map { ["title": $0.title, "description": $0.description, "id": $0.id] }
        
        Task {
            do {
                try await Firestore.firestore().collection("users").document(user.id).updateData(["news": newsDicts])
                newsTitle = ""
                newsDescription = ""
            } catch {
              print("Error writing document: \(error)")
            }
        }
    }
        
    @MainActor
    func deleteNews(atOffsets: IndexSet) {
        self.user.news.remove(atOffsets: atOffsets)

        let newsDicts = self.user.news.map { ["title": $0.title, "description": $0.description, "id": $0.id] }

        Task {
            do {
                try await Firestore.firestore().collection("users").document(user.id).updateData(["news": newsDicts])
            } catch {
              print("Error writing document: \(error)")
            }
        }
    }
    
    @MainActor
    func getUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Task {
            do {
                guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
                self.user = try snapshot.data(as: User.self)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
