//
//  NetworkManger.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 07/03/2023.
//

import Foundation


class NetworkManger {
    static func loginUser(username: String, password: String, completion: @escaping (Result<User, Error>) -> ()) {
        let credentials = ["username": username, "password": password]
        let jsonData = try! JSONSerialization.data(withJSONObject: credentials, options: [])
        let url = URL(string: "https://dummyjson.com/auth/login")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "loginUser", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP Response"])
                completion(.failure(error))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = APIError(statusCode: httpResponse.statusCode, data: data)
                completion(.failure(errorMessage))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "loginUser", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty Response Data"])
                completion(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }

    
    static func fetchPosts(completion: @escaping (Result<[Post], Error>) -> ()) {
        let url = URL(string: "https://dummyjson.com/posts")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "fetchPosts", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP Response"])
                completion(.failure(error))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "fetchPosts", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Response Error"])
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "fetchPosts", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty Response Data"])
                completion(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let PostsResponse = try decoder.decode(PostsResponse.self, from: data)
                completion(.success(PostsResponse.posts))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }

}
