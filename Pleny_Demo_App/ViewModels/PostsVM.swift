//
//  PostsVM.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 09/03/2023.
//

import Foundation
import UIKit
//@MainActor
class PostsVM: ObservableObject, RandomAccessCollection {
    typealias Element = Post
    
    @Published var user: PostUser = PostUser(id: 0, firstName: "", lastName: "", email: "", phone: "", username: "", image: URL(string: "https://robohash.org/hicveldicta.png")!)
    @Published var posts: [Post] = []
    @Published var searchResults: [Post] = []
    
    var startIndex: Int { posts.startIndex }
    var endIndex: Int { posts.endIndex }
    var nextPageToLoad = 1
    var currentlyLoading = false
    
    subscript(position: Int) -> Post { return posts[position] }
    
    init() {
        fetchPosts()
    }
    
    func shouldLoadMoreData(currentItem: Post? = nil) -> Bool{
        if currentlyLoading{
            return false
        }
        
        guard let currentItem = currentItem else { return true }
        for n in (posts.count - 4)...(posts.count - 1){
            if n >= 0 && currentItem.id == posts[n].id{
                return true
            }
        
        }
        return false
    }
    
    func fetchPosts(currentItem: Post? = nil) {
        if !shouldLoadMoreData(currentItem: currentItem){
            return
        }
        currentlyLoading = true
        
        NetworkManger.fetchPosts(page: 1) { result in
            switch result {
            case .success(let posts):
                DispatchQueue.main.async {
                    self.posts.append(contentsOf: posts)
                    self.nextPageToLoad += 1
                    self.currentlyLoading = false
                }
            case .failure(let failure):
                print(failure.localizedDescription)
                self.currentlyLoading = false
            }
        }
    }
    
    func fetchSearch(searchTerm: String){
        NetworkManger.searchPost(searchTerm: searchTerm) { result in
            switch result {
            case .success(let posts):
                DispatchQueue.main.async {
                    self.searchResults = posts
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func fetchUser(id: Int) async {
        NetworkManger.fetchUser(userID: id) { result in
            switch result {
            case .success(let postUser):
                DispatchQueue.main.async {
                    self.user = postUser
                }
            case .failure(_):
                print("Error")
            }
        }
    }
    
}

