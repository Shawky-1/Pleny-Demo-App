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
    // MARK: - Properties

    // User object to store the user data
    @Published var user: PostUser = PostUser(id: 0, firstName: "", lastName: "", email: "", phone: "", username: "", image: URL(string: "https://robohash.org/hicveldicta.png")!)

    // Array of posts
    @Published var posts: [Post] = []

    // Array of posts used for search results
    @Published var searchResults: [Post] = []

    // Index for the start of the collection
    var startIndex: Int { posts.startIndex }

    // Index for the end of the collection
    var endIndex: Int { posts.endIndex }

    // Page to load next
    var nextPageToLoad = 1

    // Boolean flag indicating whether data is being loaded currently
    var currentlyLoading = false

    // MARK: - Collection Functions

    // Subscript for accessing elements of the collection
    subscript(position: Int) -> Post { return posts[position] }

    // MARK: - Initialization

    init() {
        // Fetch the initial set of posts
        fetchPosts()
    }

    // MARK: - Public Functions

    // Function to determine if more data should be loaded
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

    // Function to fetch posts
    func fetchPosts(currentItem: Post? = nil) {
        // Check if more data should be loaded
        if !shouldLoadMoreData(currentItem: currentItem){
            return
        }
        
        // Set currentlyLoading to true to indicate that data is being loaded
        currentlyLoading = true
        
        // Fetch the posts from the network manager
        NetworkManger.fetchPosts(page: nextPageToLoad) { result in
            switch result {
            case .success(let posts):
                DispatchQueue.main.async {
                    // Append the fetched posts to the current posts array
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

    // Function to fetch search results
    func fetchSearch(searchTerm: String){
        // Fetch search results from the network manager
        NetworkManger.searchPost(searchTerm: searchTerm) { result in
            switch result {
            case .success(let posts):
                DispatchQueue.main.async {
                    // Set the searchResults array to the fetched search results
                    self.searchResults = posts
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }

    // Function to fetch user data
    func fetchUser(id: Int) async {
        // Fetch the user data from the network manager
        NetworkManger.fetchUser(userID: id) { result in
            switch result {
            case .success(let postUser):
                DispatchQueue.main.async {
                    // Set the user object to the fetched user data
                    self.user = postUser
                }
            case .failure(_):
                print("Error")
            }
        }
    }

}

