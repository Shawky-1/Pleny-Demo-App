//
//  PostsView.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 08/03/2023.
//

import SwiftUI

struct PostsView: View {

    let user: User
    let postUser = PostUser(id: 0, firstName: "Ahmed", lastName: "Alabiad", email: "Ahmed@gmail.com", phone: "01061520610", username: "Username", image: URL(string: "")!)

    @StateObject var viewModel = PostsVM()
    var body: some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(viewModel.post) { post in
                            PostView(post: post, user: postUser)
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
        let userReview = User(id: 2, username: "Ahmed22", email: "Ahmed@Test.com", firstName: "Ahmed", lastName: "Alabiad", gender: "Male", image: "", token: "")

        PostsView(user: userReview)
    }
}
