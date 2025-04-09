//
//  SettingsView.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/8/25.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            
            VStack {
                NavigationLink {
                    AccountDetailView(viewModel: AccountDetailViewModel(firstName: authViewModel.currentUser?.name ?? "", lastName: authViewModel.currentUser?.lastName ?? "", email: authViewModel.currentUser?.email ?? ""))
                } label: {
                    HStack {
                        Image(systemName: "person.crop.circle")
                        Spacer().frame(width: 20)
                        Text("Account Details")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.black)
                }
             
                Spacer()
                
                Text("Sign Out")
                    .bold()
                    .foregroundColor(.red)
                    .onTapGesture {
                        do {
                            try authViewModel.signOut()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
