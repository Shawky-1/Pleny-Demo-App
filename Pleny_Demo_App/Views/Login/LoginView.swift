//
//  ContentView.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 07/03/2023.
//

import SwiftUI


struct LoginView: View {
    @StateObject var viewModel = LoginVM()
    
    @State private var username = ""
    @State private var password = ""
    @State private var user: User? = nil
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                Image("Login_Place_Holder")
                    .resizable()
                    .scaledToFill()
                    .frame(height:400)
                    .clipped()
                    .ignoresSafeArea()
                Text("Welcome")
                    .font(.system(size: 25, weight: .heavy))
                    .foregroundColor(Color.init(red: 63/255, green: 63/255, blue: 209/255))
                    .padding(.top, -35)
                
                
                Spacer()
                VStack(alignment: .leading, spacing: 6){
                    Text("User name")
                        .font(.system(size: 20, weight: .medium))
                    TextField("Enter your user name", text: $username)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.init(red: 208/255, green: 213/255, blue: 221/255), style: StrokeStyle(lineWidth: 1.0)))
                }.padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 6){
                    Text("Password")
                        .font(.system(size: 20, weight: .medium))
                    SecureField("Enter your user name", text: $password)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.init(red: 208/255, green: 213/255, blue: 221/255), style: StrokeStyle(lineWidth: 1.0)))
                }.padding()
                
                Button(action: {
                    viewModel.login(username: username, password: password)
                }) {
                    Text("Sign in").frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(Color.white)
                }.buttonStyle(.plain)
                    .background(Color.init(red: 63/255, green: 63/255, blue: 209/255))
                    .mask(RoundedRectangle(cornerRadius: 30))
                    .cornerRadius(25)
                    .padding()
                
                Spacer()
            }
            if let user = user {
                Text("Logged in as \(user.username)")
            }
        }
    }
    
}





struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
