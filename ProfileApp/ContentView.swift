//
//  ContentView.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/7/25.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if(viewModel.userSession != nil) {
                TabView {
                    ProfileView()
                        .tabItem {
                            Text("Home")
                            Image(systemName: "house.fill")
                                .renderingMode(.template)
                        }
                    
                    ExploreView()
                        .tabItem {
                            Text("Explore")
                            Image(systemName: "eye.fill")
                                .renderingMode(.template)
                        }
                    
                    SettingsView()
                        .onAppear {
                            Task {
                                await viewModel.getUser()
                            }
                        }
                        .tabItem {
                            Text("Settings")
                            Image(systemName: "gearshape")
                                .renderingMode(.template)
                        }
                }
            } else {
                LoginScreenView()
            }
        }
        
    }
}

#Preview {
    ContentView()
}
