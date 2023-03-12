//
//  Post.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 08/03/2023.
//

import Foundation


struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
    let tags: [String]?
    let reactions: Int?
    let images: [String]?
}

struct PostsResponse: Codable {
    let posts: [Post]
    let total: Int
    let skip: Int
    let limit: Int
}

