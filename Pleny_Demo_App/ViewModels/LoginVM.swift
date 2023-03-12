//
//  LoginVM.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 07/03/2023.
//

import Foundation

@MainActor
class LoginVM: ObservableObject {
    // MARK: - Published Properties
    
    @Published var user: User?
    @Published var error: String?
    
    // MARK: - Public Functions
    
    // This function takes username, password, and a completion block as parameters.
    // It calls NetworkManager to login the user and passes the result to the completion block.
    // If the login is successful, it sets the user property, saves the user data to UserDefaults, and calls the completion block.
    // If the login fails, it sets the error property with an appropriate error message.
    func login(username: String, password: String, completion: @escaping () -> Void) {
        Task{
            NetworkManger.loginUser(username: username, password: password) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.user = user
                        self.saveUser(user: user)
                        completion()
                    }
                case .failure(let failure):
                    switch failure as? APIError{
                    case .unauthorized(let string):
                        DispatchQueue.main.async {
                            self.error = string
                        }
                    default:
                        DispatchQueue.main.async {
                            self.error = "Error occurred"
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Private Functions
    
    // This function takes a user as a parameter and saves its data to UserDefaults.
    private func saveUser(user: User){
        UserDefaults.standard.set(user.firstName, forKey: "firstName")
        UserDefaults.standard.set(user.lastName, forKey: "lastName")
        UserDefaults.standard.set(user.id, forKey: "id")
        UserDefaults.standard.set(user.token, forKey: "token")
    }
}
