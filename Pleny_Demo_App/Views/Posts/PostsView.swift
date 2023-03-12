//
//  PostsView.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 08/03/2023.
//

import SwiftUI

struct PostsView: View {
    @StateObject var viewModel = PostsVM()
    @State private var searchText:String = ""
    let user: User
    
    var body: some View {
        NavigationView {
            if searchText.isEmpty{
                if viewModel.posts.isEmpty{
                    Text("No results")
                } else {
                    List(viewModel) { (post: Post) in
                        
                        PostView(post: post)
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 10)
                            .onAppear {
                                viewModel.fetchPosts(currentItem: post)
                            }
                    }
                    .listStyle(PlainListStyle())
                }
            }else {
                List(viewModel.searchResults) { post in
                    Text(post.title)
                }
            }
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { newValue in
            if newValue.count > 2 {
                viewModel.fetchSearch(searchTerm: newValue)
            }
        }
    }
    
}


struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        let userReview = User(id: 2, username: "Ahmed22", email: "Ahmed@Test.com", firstName: "Ahmed", lastName: "Alabiad", gender: "Male", image: "", token: "")
        
        PostsView(user: userReview)
    }
}
