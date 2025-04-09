//
//  AccountDetailView.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/8/25.
//

import SwiftUI

struct AccountDetailView: View {
    
    @ObservedObject var viewModel: AccountDetailViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            NavigationView {
            
                    Form {
                        Section("Account") {
                            TextField("First Name", text: $viewModel.firstName)
                            TextField("Last Name", text: $viewModel.lastName)
                            TextField("Email", text: $viewModel.email)
                        }
                        
                        Text("Update Account")
                            .bold()
                            .foregroundColor(.blue)
                            .onTapGesture() {
                                Task {
                                    await viewModel.updateUser(uid: authViewModel.currentUser?.id ?? "")
                                }
                            }
                        
                        Text("Delete Account")
                            .bold()
                            .foregroundColor(.red)
                            .onTapGesture() {
                                Task {
                                    do {
                                        try await authViewModel.deleteUser(uid: authViewModel.currentUser?.id ?? "")
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                    }
                .navigationTitle("Account Details")
            }
            
            if(viewModel.isLoading) {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.white)
            }
        }
    }
}

