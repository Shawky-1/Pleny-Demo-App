//
//  PostsVM.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 09/03/2023.
//

import Foundation

@MainActor
class PostsVM: ObservableObject {
    
    @Published var user: User?
    @Published var post: [Post] = []

    
    func fetchPosts(){
        NetworkManger.fetchPosts { result in
            switch result {
            case .success(let posts):
                self.post = posts
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
}
