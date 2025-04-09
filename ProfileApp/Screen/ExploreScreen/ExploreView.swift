//
//  ExploreView.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/7/25.
//

import SwiftUI

struct ExploreView: View {
    
    @StateObject var viewModel = ExploreViewModel()
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $viewModel.userName)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .submitLabel(.done)
                
                Spacer().frame(height: 30)
                
                ScrollView {
                    ForEach(viewModel.userList, id: \.id) { user in
                        VStack() {
                            HStack {
                                Image(systemName: user.image)
                                Text(user.name + user.lastName)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            Spacer().frame(height: 12)
                        }
                        .onTapGesture {
                            viewModel.isDetailActive = true
                            viewModel.selectedUser = user
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Explore")
        }
        .sheet(isPresented: $viewModel.isDetailActive) {
            UserDetailView(viewModel: UserDetailViewModel(user: viewModel.selectedUser!, isDetailActive: $viewModel.isDetailActive))
        }
        .onAppear {
            viewModel.getSearchUser()
        }
    }
}

#Preview {
    ExploreView()
}
