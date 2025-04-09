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
    let followers: Int
    let following: Int
}

struct News: Codable {
    let title: String
    let id: String
    let description: String
}
