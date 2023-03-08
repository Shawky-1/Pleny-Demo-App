//
//  PostView.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 08/03/2023.
//

import SwiftUI

struct PostView: View {
    
    let post: Post
    let user: User
    var body: some View {
        VStack(spacing: 8) {
            HeaderView(user: user, timestamp: "today")
            PostBodyView(post: post)
            PostImagesView(images: post.images)
                .cornerRadius(8)
        }
//        .background(Color.gray)
        .padding()
    }
}

struct HeaderView: View {
    
    let user: User
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

struct UserAvatarView: View {
    
    let image: String
    
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .clipped()
            .mask(Circle())
    }
}

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
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: geometry.size.width,maxHeight: geometry.size.height ,alignment: .center)
                .clipped()
        }
    }
}

                              

struct PostImageGridView: View {
    
    let images: [String]
    
    var body: some View {
        HStack(spacing: 4) {
            VStack(spacing: 4) {
                PostImageItemView(image: images[0])
                PostImageItemView(image: images[1])
            }
            VStack(spacing: 4) {
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
        .frame(maxHeight: 343)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: 3, username: "AhmedAlabiad", email: "Ahmed@Test.com", firstName: "Ahmed", lastName: "Alabiad", gender: "Male", image: "Login_Place_Holder", token: "")
        let post = Post(id: 5, title: "Title", body: "Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text Lots of text", userId: 25, tags: [""], reactions: 5, images: ["Login_Place_Holder","Login_Place_Holder","Login_Place_Holder","Login_Place_Holder","Login_Place_Holder",])
        PostView(post: post, user: user)
    }
}
