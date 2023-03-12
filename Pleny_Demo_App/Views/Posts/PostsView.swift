//
//  PostsView.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 08/03/2023.
//

import SwiftUI

struct PostsView: View {
    @StateObject var viewModel = PostsVM()
    @State private var search:String = ""
    let user: User

    var body: some View {
        NavigationView {
            
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
        .searchable(text: $search)
    }
    
}


struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        let userReview = User(id: 2, username: "Ahmed22", email: "Ahmed@Test.com", firstName: "Ahmed", lastName: "Alabiad", gender: "Male", image: "", token: "")
        
        PostsView(user: userReview)
    }
}
