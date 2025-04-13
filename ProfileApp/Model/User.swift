//
//  User.swift
//  ProfileApp
//
//  Created by Emre Bingor on 4/7/25.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let image: String
    let email: String
    let lastName: String
    var news: [News]
    var followers: [FollowInformation]
    var following: [FollowInformation]
}

struct FollowInformation: Codable {
    let name: String
    let lastName: String
    let id: String
}

struct News: Codable {
    let title: String
    let id: String
    let description: String
    let likes: Int
}
