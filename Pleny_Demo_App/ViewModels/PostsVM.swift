//
//  PostsVM.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 09/03/2023.
//

import Foundation
import UIKit
@MainActor
class PostsVM: ObservableObject {
    
    @Published var user: User?
    @Published var post: [Post] = []

    
    func fetchPosts(){
        Task{
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
    
    func fetchUser(id: Int, completion: @escaping (Result<PostUser, Error>) -> ()) {
        NetworkManger.fetchUser(userID: id) { result in
            switch result {
            case .success(let postUser):
                completion(.success(postUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
