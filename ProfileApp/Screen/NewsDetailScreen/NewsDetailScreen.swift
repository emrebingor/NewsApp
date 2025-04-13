//
//  NewsDetailScreen.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/9/25.
//

import SwiftUI

struct NewsDetailScreen: View {
    
    @ObservedObject var viewModel: NewsDetailViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(viewModel.news.title)
                            .font(.title3)
                        Spacer().frame(height: 12)
                        Text(viewModel.news.description)
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Spacer().frame(height: 12)
                    }
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("News Detail")
        }
    }
}


