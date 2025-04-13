//
//  UserDetailView.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/9/25.
//

import SwiftUI

struct UserDetailView: View {
    
    @ObservedObject var viewModel: UserDetailViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                Text(viewModel.user.name + " " + viewModel.user.lastName)
                    .font(.title)
                
                Image(systemName: viewModel.user.image)
                    .resizable()
                    .frame(width: 100, height: 90)
                
                
                Button {
                    
                    Task {
                        await viewModel.updateFollowNumber()
                    }
                    
                } label: {
                    Text(viewModel.currentUser.following.contains(where: { $0.id == viewModel.user.id}) ? "Unfollow" : "Follow")
                }
                .frame(width: 100, height: 30)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                HStack(spacing: 30) {
                    NavigationLink {
                        FollowerDetailView()
                    } label: {
                        HStack {
                            FollowInformationText(title: "Followers", number: viewModel.user.followers.count)
                            FollowInformationText(title: "Followings", number: viewModel.user.following.count)
                        }
                    }
                 
                }
                
                ForEach(viewModel.user.news, id: \.id) { news in
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(news.title)
                                .lineLimit(1)
                                .bold()
                            Text(news.description)
                                .lineLimit(2)
                                .font(.caption)
                        }
                        Spacer()
                        
                        Text("See Details")
                            .frame(width: 60, height: 20)
                            .padding(.all, 4)
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.black, lineWidth: 1)
                            )
                    }
                    .onTapGesture {
                        viewModel.isNewsDetailActive = true
                        viewModel.selectedNews = news
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.black, lineWidth: 1)
                    )
                }
            }
            .padding()
            .navigationTitle("User Detail")
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.isDetailActive.wrappedValue = false
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Explore")
                        }

                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isNewsDetailActive) {
            NewsDetailScreen(viewModel: NewsDetailViewModel(news: viewModel.selectedNews!, isDetailActive: $viewModel.isNewsDetailActive))
                .presentationDetents([.fraction(0.8)])
        }
    }
}
