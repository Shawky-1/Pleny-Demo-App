//
//  ContentView.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 07/03/2023.
//

import SwiftUI


struct LoginView: View {
    // ViewModel for handling login process
    @StateObject var viewModel = LoginVM()

    // State variables for username, password and full screen cover presentation
    @State private var username = ""
    @State private var password = ""
    @State private var isPresented = false

    var body: some View {
        NavigationStack {
            VStack {
                // Image placeholder
                Image("Login_Place_Holder")
                    .resizable()
                    .scaledToFill()
                    .frame(height:400)
                    .clipped()
                    .ignoresSafeArea()
                
                // Title text
                Text("Welcome")
                    .font(.system(size: 25, weight: .heavy))
                    .foregroundColor(Color.init(red: 63/255, green: 63/255, blue: 209/255))
                    .padding(.top, -35)
                
                Spacer()
                
                // Username input field
                VStack(alignment: .leading, spacing: 6){
                    Text("User name")
                        .font(.system(size: 20, weight: .medium))
                    TextField("Enter your user name", text: $username)
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 10.0)
                                    .strokeBorder(Color.init(red: 208/255, green: 213/255, blue: 221/255), style: StrokeStyle(lineWidth: 1.0)))
                }.padding(.horizontal)
                
                // Password input field
                VStack(alignment: .leading, spacing: 6){
                    Text("Password")
                        .font(.system(size: 20, weight: .medium))
                    SecureField("Enter your password", text: $password)
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 10.0)
                                    .strokeBorder(Color.init(red: 208/255, green: 213/255, blue: 221/255), style: StrokeStyle(lineWidth: 1.0)))
                }.padding()
                
                // Sign in button
                Button(action: {
                    viewModel.login(username: username, password: password) {
                        isPresented.toggle()
                    }
                }) {
                    Text("Sign in")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(Color.white)
                }.fullScreenCover(isPresented: $isPresented) {
                    // Present PostsView upon successful login
                    PostsView(user: viewModel.user!)
                }
                .buttonStyle(.plain)
                .background(Color.init(red: 63/255, green: 63/255, blue: 209/255))
                .mask(RoundedRectangle(cornerRadius: 30))
                .cornerRadius(25)
                .padding()
                
                Spacer()
            }
            
            // Show error message if there was a login error
            if (viewModel.error != nil){
                Text("Couldn't log in: " + (viewModel.error ?? ""))
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

