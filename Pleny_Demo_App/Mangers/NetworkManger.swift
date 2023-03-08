//
//  NetworkManger.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 07/03/2023.
//

import Foundation


class NetworkManger {
    static func loginUser(username: String, password: String , completion : @escaping (Result<User, Error>) -> ()) {
        let credentials = ["username": username, "password": password]
        let jsonData = try! JSONSerialization.data(withJSONObject: credentials, options: [])
        let url = URL(string: "https://dummyjson.com/auth/login")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard let data = data else {
                    throw APIError.unknown(0)
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.unknown(0)
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    let decoder = JSONDecoder()
                    if let user = try? decoder.decode(User.self, from: data) {
                        completion(.success(user))
                    } else {
                        throw APIError.unknown(httpResponse.statusCode)
                    }
                    
                case 400:
                    let errorMessage = APIError(statusCode: httpResponse.statusCode, data: data)
                    completion(.failure(errorMessage))
                    
                default:
                    throw APIError(statusCode: httpResponse.statusCode, data: data)
                }
            } catch let error as APIError {
                print(error.localizedDescription)
                completion(.failure(error))
            } catch {
                print("An error occurred: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()

    }
}
