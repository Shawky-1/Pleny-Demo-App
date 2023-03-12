//
//  PostsView.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 08/03/2023.
//

import SwiftUI

struct PostsView: View {
    @StateObject var viewModel = PostsVM() // Holds the PostsVM class instance.
    @State private var searchText:String = "" // Holds the current search text.
    let user: User // User object to display posts for.
    
    var body: some View {
        NavigationView {
            if searchText.isEmpty {
                if viewModel.posts.isEmpty {
                    Text("No results") // Display "No results" text if there are no posts.
                } else {
                    List(viewModel) { (post: Post) in
                        PostView(post: post) // Display the post.
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 10)
                            .onAppear {
                                viewModel.fetchPosts(currentItem: post) // Fetch more posts when the user scrolls to the last item.
                            }
                    }
                    .listStyle(PlainListStyle())
                }
            } else {
                List(viewModel.searchResults) { post in
                    Text(post.title) // Display the search result.
                }
            }
        }
        .searchable(text: $searchText) // Search bar to filter posts by title.
        .onChange(of: searchText) { newValue in
            if newValue.count > 2 {
                viewModel.fetchSearch(searchTerm: newValue) // Fetch search results if the search text has more than 2 characters.
            }
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        let userReview = User(id: 2, username: "Ahmed22", email: "Ahmed@Test.com", firstName: "Ahmed", lastName: "Alabiad", gender: "Male", image: "", token: "")
        PostsView(user: userReview) // Preview of the PostsView with the user object passed in.
    }
}
