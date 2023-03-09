//
//  PostsView.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 08/03/2023.
//

import SwiftUI

struct PostsView: View {
    @StateObject var viewModel = PostsVM()
    let user = User(id: 2, username: "Ahmed22", email: "Ahmed@Test.com", firstName: "Ahmed", lastName: "Alabiad", gender: "Male", image: "", token: "")
    var body: some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(viewModel.post) { post in
                            PostView(post: post, user: user)
                    }
                }
                .padding(.horizontal)
            }
        }.onAppear {
            viewModel.fetchPosts()
        }
    }

}


struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
