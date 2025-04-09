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
            VStack{
                ForEach(viewModel.user.news, id: \.id) { news in
                    VStack {
                        Text(news.title)
                        Spacer().frame(height: 12)
                        Text(news.description)
                        Spacer().frame(height: 12)
                        Divider()
                    }
                }
            }
            .navigationTitle("News Detail")
        }
    }
}
