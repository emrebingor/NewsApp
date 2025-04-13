//
//  ProfileView.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/7/25.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
        
    var body: some View {
        NavigationView {
            
            ScrollView {
                VStack(alignment: .center) {
                    Text(viewModel.user.name + " " + viewModel.user.lastName)
                        .font(.title)
                    
                    ZStack(alignment: .topTrailing) {
                        if let image = viewModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 100, height: 90)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: viewModel.user.image)
                                .resizable()
                                .frame(width: 100, height: 90)
                        }
                        
                        PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }

                    HStack(spacing: 30) {
                        FollowInformationText(title: "Followers", number: viewModel.user.followers.count)
                        FollowInformationText(title: "Followings", number: viewModel.user.following.count)
                    }
                    
                    Spacer().frame(height: 30)

                    TextField("Title", text: $viewModel.newsTitle)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .submitLabel(.done)
                    
                    Spacer().frame(height: 20)

                    TextField("Description", text: $viewModel.newsDescription, axis: viewModel.newsDescription.isEmpty ? .horizontal :.vertical)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .submitLabel(.done)
                    
                    
                    Spacer().frame(height: 20)

                    Button {
                        viewModel.addNews()
                    } label: {
                         Text("Add News")
                    }
                    .frame(width: 350, height: 50)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(16)
                    
                    Spacer().frame(height: 20)

                    if(!viewModel.user.news.isEmpty) {
                        
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
                                    viewModel.isDetailActive = true
                                    viewModel.selectedNews = news
                                }
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.black, lineWidth: 1)
                                )
                            }
                        
                    }
                    Spacer()
                }

            }

            .padding()
            .navigationTitle("Profile")
        }
        .sheet(isPresented: $viewModel.isDetailActive) {
            NewsDetailScreen(viewModel: NewsDetailViewModel(news: viewModel.selectedNews!, isDetailActive: $viewModel.isDetailActive))
        }
        .onChange(of: viewModel.imageSelection) { newItem in
            viewModel.setImage(data: newItem)
        }
        .onAppear {
            viewModel.getUser()
        }
    }
}

#Preview {
    ProfileView()
}

struct FollowInformationText: View {
    
    var title: String
    var number: Int
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
            Text("\(number)")
                .font(.title3)
        }
        .foregroundColor(.black)
    }
}
