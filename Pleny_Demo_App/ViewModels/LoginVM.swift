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
    @Published var error: String?

    func login(username: String, password: String, completion: @escaping () -> Void) {
        NetworkManger.loginUser(username: username, password: password) { [weak self] result in
            guard let self = self else { return }

            Task {
                switch result {
                case .success(let user):
                    self.user = user
                    self.saveUser(user: user)
                    completion()

                case .failure(let failure):
                    switch failure as? APIError{
                    case .unauthorized(let string):
                        self.error = string
                    default:
                        self.error = "Error occured"
                    }
                }
            }
        }
    }

    func saveUser(user: User){
        UserDefaults.standard.set(user.firstName, forKey: "firstName")
        UserDefaults.standard.set(user.lastName, forKey: "lastName")
        UserDefaults.standard.set(user.id, forKey: "id")
        UserDefaults.standard.set(user.token, forKey: "token")
    }
}
