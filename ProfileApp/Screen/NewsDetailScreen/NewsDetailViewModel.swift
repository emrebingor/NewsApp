//
//  UserDetailViewModel.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/9/25.
//

import Foundation
import SwiftUI

final class NewsDetailViewModel: ObservableObject {
    
    let news: News
    var isDetailActive: Binding<Bool>
    
    init(news: News, isDetailActive: Binding<Bool>) {
        self.news = news
        self.isDetailActive = isDetailActive
    }
    
}
