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
    let images = ["https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8&w=1000&q=80", "https://cdn.pixabay.com/photo/2010/12/13/10/05/berries-2277_960_720.jpg", "https://upload.wikimedia.org/wikipedia/commons/b/ba/Lasagne_-_stonesoup.jpg", "https://cdnprod.mafretailproxy.com/sys-master-root/hc2/h23/35140086333470/1700Wx1700H_397729_main.jpg", "https://cdn.britannica.com/36/123536-050-95CB0C6E/Variety-fruits-vegetables.jpg", "https://www.teenaagnel.com/wp-content/uploads/2019/12/food-photography-in-dubai.jpg" ]

    var n = Int.random(in: 1...6)

    var body: some View {
        VStack(spacing: 8) {
            HeaderView(user: viewModel.user, timestamp: "today")
            PostBodyView(post: post)
            let randomImageIndex = Int.random(in: 0..<images.count)
            let randomNumberOfImages = Int.random(in: 1...images.count - randomImageIndex)
            let selectedImages = Array(images[randomImageIndex..<randomImageIndex+randomNumberOfImages])

            PostImagesView(images: [images[1]] )
                .cornerRadius(8)
        }.task {
            await viewModel.fetchUser(id: post.userId)

        }
    }
}
//MARK: - Header View
struct HeaderView: View {
    
    let user: PostUser
    let timestamp: String
    
    var body: some View {
        HStack(spacing: 8) {
            UserAvatarView(image: user.image)
            VStack(alignment: .leading) {
                Text("\(user.firstName) \(user.lastName)")
                    .font(.system(size: 17, weight: .bold))
                Text(timestamp)
                    .font(.system(size: 13, weight: .light))
            }
            Spacer()
        }
        .frame(height: 40)
    }
}
///Avatar loader
struct UserAvatarView: View {
    
    let image: URL
    
    var body: some View {
        AsyncImage(url: image) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .mask(Circle())
                .clipped()

        } placeholder: {
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
//                    .mask(Circle())

            } placeholder: {
                Rectangle().fill(Color(red:61/255,green:61/255,blue:88/255))
                .frame(maxWidth: geometry.size.width,maxHeight: geometry.size.height ,alignment: .center)
                
            }
        }
    }
}

                              

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
        let user = PostUser(id: 0, firstName: "Ahmed", lastName: "Alabiad", email: "Ahmed@gmail.com", phone: "01061520610", username: "Username", image: URL(string: "https://robohash.org/hicveldicta.png")!)
        let post = Post(id: 5, title: "Title", body: "Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text", userId: 25, tags: [""], reactions: 5, images: ["Rectangle1","Rectangle", "Rectangle2"])
        PostView(post: post)
    }
}
