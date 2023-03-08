//
//  LoginVM.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 07/03/2023.
//

import Foundation

@MainActor
class LoginVM: ObservableObject {
    
    @Published var user: User?
    
    func loadTrending() {
        
    }
    
    func login(username: String, password: String) {
        
        NetworkManger.loginUser(username: username, password: password) { result in
            Task{
                switch result {
                case .success(let user):
                    self.user = user
                    
                case .failure(let failure):
                    switch failure as? APIError{
                    case .unauthorized(let string):
                        print(string)
                    case .none:
                        print (".none")
                    case .some(.badRequest):
                        print (".badRequest")
                    case .some(.accessDenied):
                        print (".accessDenied")
                        
                    case .some(.resourceNotFound):
                        print (".resourceNotFound")
                        
                    case .some(.unknown(let error)):
                        print (error)
                        
                    case .some(.statusCode(_, data: let data)):
                        print (".badRequest, \(data)")
                        
                    }
                }
            }
        }
        
    }
    
    func saveUser(){
        
    }
    
    
}
