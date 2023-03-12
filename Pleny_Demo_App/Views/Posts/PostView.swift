//
//  PostView.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 08/03/2023.
//

import SwiftUI

struct PostView: View {
    
    let post: Post
    @StateObject var viewModel = PostsVM()
    
    // An array of URLs for random images
    let images = [        "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8&w=1000&q=80",        "https://cdn.pixabay.com/photo/2010/12/13/10/05/berries-2277_960_720.jpg",        "https://upload.wikimedia.org/wikipedia/commons/b/ba/Lasagne_-_stonesoup.jpg",        "https://cdnprod.mafretailproxy.com/sys-master-root/hc2/h23/35140086333470/1700Wx1700H_397729_main.jpg",        "https://cdn.britannica.com/36/123536-050-95CB0C6E/Variety-fruits-vegetables.jpg",        "https://www.teenaagnel.com/wp-content/uploads/2019/12/food-photography-in-dubai.jpg"    ]

    // A random number between 1 and 6 used to select a random image from the array
    var n = Int.random(in: 1...6)

    var body: some View {
        VStack(spacing: 8) {
            // HeaderView with user and timestamp information
            PostHeaderView(user: viewModel.user, postTimestamp: "today")
            // PostBodyView with the content of the post
            PostBodyView(post: post)
            // Select a random number of images starting at a random index
            let randomImageIndex = Int.random(in: 0..<images.count)
            let randomNumberOfImages = Int.random(in: 1...images.count - randomImageIndex)
            let selectedImages = Array(images[randomImageIndex..<randomImageIndex+randomNumberOfImages])
            // try replacing the [images[1]] with selectedImages to review
            ///note: Using selectedImages variable will lead to some UI bugs because everytime you load new images, it gets randomized again
            PostImagesView(images: selectedImages )
                .cornerRadius(8)
        }.task {
            // Fetch the user associated with the post using the view model
            await viewModel.fetchUser(id: post.userId)
        }
    }
}
//MARK: - Header View
struct PostHeaderView: View {
    // User who posted the post
    let user: PostUser
    // Timestamp of the post
    let postTimestamp: String
    
    var body: some View {
        HStack(spacing: 8) {
            // Display user avatar
            UserAvatarView(image: user.image)
            VStack(alignment: .leading) {
                // username
                Text("\(user.firstName) \(user.lastName)")
                    .font(.system(size: 17, weight: .bold))
                //post timestamp
                Text(postTimestamp)
                    .font(.system(size: 13, weight: .light))
            }
            Spacer()
        }
        .frame(height: 40)
    }
}
/// A view that displays a user avatar image loaded asynchronously from a URL.
struct UserAvatarView: View {
    // URL of the user avatar image
    let image: URL
    
    var body: some View {
        //avatar Image
        AsyncImage(url: image) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .mask(Circle())
                .clipped()
        } placeholder: {///placeholder image
            Rectangle().fill(Color(red:61/255,green:61/255,blue:88/255))
                    .frame(width: 40, height: 40)
                    .mask(Circle())
        }
    }
}
//MARK: - Body View
struct PostBodyView: View {
    
    let post: Post
    var body: some View {
        ///body of the view
        Text(post.body)
            .font(.system(size: 17, weight: .regular))
            .lineLimit(4)
    }
}

struct PostImagesView: View {
    
    let images: [String]?
    
    var body: some View {
        if let images = images {
            switch images.count {
            case 0:
                EmptyView()
            case 1:
                PostImageRowView(images: images, rowSize: .single)
            case 2:
                PostImageRowView(images: images, rowSize: .double)
            case 3:
                PostImageRowView(images: images, rowSize: .triple)
            default:
                PostImageGridView(images: images)
            }
        }
    }
}

enum PostImageRowSize {
    case single
    case double
    case triple
}

/// A view that displays a row of post images
struct PostImageRowView: View {
    
    let images: [String]
    let rowSize: PostImageRowSize
    
    var body: some View {
        switch rowSize {
        case .single:
            PostImageItemView(image: images[0])
                .frame(height: 250)
        case .double:
            HStack(spacing: 4) {
                PostImageItemView(image: images[0])
                PostImageItemView(image: images[1])


            }.frame(height: 250)
        case .triple:
            HStack(spacing: 4) {
                PostImageItemView(image: images[0])
                VStack(spacing: 4) {
                    PostImageItemView(image: images[1])
                    PostImageItemView(image: images[2])
                }
            }
            .frame(height: 343)
        }
    }
}
///A view that displays a single image
struct PostImageItemView: View {
    
    let image: String
    
    var body: some View {
        GeometryReader { geometry in
            AsyncImage(url: URL(string:image)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: geometry.size.width,maxHeight: geometry.size.height ,alignment: .center)
                    .clipped()
            } placeholder: {
                Rectangle().fill(Color(red:61/255,green:61/255,blue:88/255))
                .frame(maxWidth: geometry.size.width,maxHeight: geometry.size.height ,alignment: .center)
                
            }
        }
    }
}

                              
///view that displays 4+ images
struct PostImageGridView: View {
    
    let images: [String]
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                PostImageItemView(image: images[0])
                PostImageItemView(image: images[1])
            }
            HStack(spacing: 4) {
                PostImageItemView(image: images[2])
                if images.count > 4{
                    ZStack{
                        PostImageItemView(image: images[3])
                            .opacity(0.35)
                            .background(Color.init(red: 52/255, green: 64/255, blue: 84/255, opacity:1))
                        
                        Text("+\((images.count) - 4)")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(Color.white)
                    }
                } else {
                    PostImageItemView(image: images[3])
                }
                
            }
        }
        .frame(height: 343)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        //placeholder variables
        let post = Post(id: 5, title: "Title", body: "Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text", userId: 25, tags: [""], reactions: 5, images: ["Rectangle1","Rectangle", "Rectangle2"])
        PostView(post: post)
    }
}
