//
//  User.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 07/03/2023.
//

import Foundation

struct User: Codable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let gender: String
    let image: String
    let token: String
}

struct PostUser: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String?
    let phone: String?
    let username: String?
    let image: URL

}





