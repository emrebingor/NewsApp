//
//  LoginScreenView.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/8/25.
//

import SwiftUI

struct LoginScreenView: View {
    
    @StateObject var viewModel = LoginViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack {
                        if(viewModel.signUp) {
                            TextField("First Name", text: $viewModel.name)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .submitLabel(.done)
                            
                            Spacer().frame(height: 10)
                            
                            TextField("Last Name", text: $viewModel.lastName)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .submitLabel(.done)
                            
                            Spacer().frame(height: 10)
                        }
            
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .submitLabel(.done)
                        
                        Spacer().frame(height: 10)

                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(.roundedBorder)
                            .autocapitalization(.none)
                            .padding(.horizontal)
                            .submitLabel(.done)
                        
                        Spacer().frame(height: 50)
                        
                        ButtonView(
                            title: viewModel.signUp ? "Sign Up" : "Sign In",
                            onTap: {
                                Task {
                                    do {
                                        if viewModel.signUp {
                                            try await authViewModel.signUp(email: viewModel.email, password: viewModel.password, name: viewModel.name, lastName: viewModel.lastName)
                                        } else {
                                            try await authViewModel.signIn(email: viewModel.email, password: viewModel.password)
                                        }
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            })
                        
                        Spacer().frame(height: 10)
                        
                        Text(viewModel.signUp ? "Already have an account" : "Don't have an account")
                            .onTapGesture {
                                viewModel.signUp = !viewModel.signUp
                            }
                    }
                }
                .navigationTitle("Login")
            }
            
            if(authViewModel.isLoading) {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.white)
            }
        }
    }
}

struct ButtonView: View {
    
    var title: String
    var onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Text(title)
        }
        .frame(width: 350, height: 50)
        .foregroundColor(.white)
        .background(.blue)
        .cornerRadius(16)
    }
}

#Preview {
    LoginScreenView()
}
