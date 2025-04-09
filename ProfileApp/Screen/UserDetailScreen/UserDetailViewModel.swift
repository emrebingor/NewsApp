//
//  UserDetailViewModel.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/9/25.
//

import Foundation
import SwiftUI

final class UserDetailViewModel: ObservableObject {
    
    let user: User
    var isDetailActive: Binding<Bool>
    
    init(user: User, isDetailActive: Binding<Bool>) {
        self.user = user
        self.isDetailActive = isDetailActive
    }
    
}
